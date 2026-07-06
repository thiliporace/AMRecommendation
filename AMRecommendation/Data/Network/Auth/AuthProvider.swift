//
//  SpotifyAuthProvider.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 01/07/26.
//

import Foundation

protocol AuthProviderProtocol: Sendable {
    // A valid access token, refreshing proactively if near expiry.
    func validAccessToken() async throws -> String
    // One-time authorization-code exchange after interactive login; persists tokens.
    func exchange(code: String, verifier: String) async throws
    // Force a refresh and return the new token (used for a 401 retry)
    func refresh() async throws -> String
    
    var isAuthenticated: Bool { get async }
    func logout() async throws
}

// The token brain. Responsible for making the token request from Spotify, returning a valid access token and refreshing tokens
actor SpotifyAuthProvider: AuthProviderProtocol {
    private let session: NetworkSessionProtocol
    private let decoder: JSONDecoder = JSONDecoder()
    private let tokenStore: TokenStoreProtocol
    private let config: SpotifyConfig
    
    private var accessToken = ""
    private var refreshToken = ""
    private var expiryDate: Date = .distantPast
    private var didBootstrap = false
    
    init(session: NetworkSessionProtocol = URLSession.shared, tokenStore: TokenStoreProtocol, config: SpotifyConfig) {
        self.session = session
        self.tokenStore = tokenStore
        self.config = config
    }
    
    var isAuthenticated: Bool {
        if !refreshToken.isEmpty { return true }
        return tokenStore.loadRefreshToken()?.isEmpty == false
    }
    
    // Ensures you always get a fresh, usable access token for making Spotify API calls.
    func validAccessToken() async throws -> String {
        initializeRefreshToken()
        if accessToken.isEmpty || Date() >= expiryDate.addingTimeInterval(-67) {
            return try await performRefresh()
        }
        
        return accessToken
    }
    
    // Manually forces a token refresh, bypassing the expiration time-check
    func refresh() async throws -> String {
        initializeRefreshToken()
        return try await performRefresh()
    }
    
    // Handles the final step of the OAuth 2.0 / PKCE login flow
    func exchange(code: String, verifier: String) async throws {
        let token = try await postToken([
            .init(name: "client_id", value: config.clientId),
            .init(name: "grant_type", value: "authorization_code"),
            .init(name: "code", value: code),
            .init(name: "redirect_uri", value: config.redirectUri),
            .init(name: "code_verifier", value: verifier)
        ])
        apply(token)
    }
    
    // Wipes out the user's authentication state
    func logout() async throws {
        accessToken = ""
        refreshToken = ""
        expiryDate = .distantPast
        didBootstrap = true
        try tokenStore.clear()
    }
    
    // Performs a lazy initialization of the authentication state from persistent disk storage
    private func initializeRefreshToken() {
        guard !didBootstrap else { return }
        didBootstrap = true
        if refreshToken.isEmpty, let storedToken = tokenStore.loadRefreshToken() {
            refreshToken = storedToken
        }
    }
    
    // Coordinates the actual network refresh routine
    private func performRefresh() async throws -> String {
        guard !refreshToken.isEmpty else { throw AppErrorEnum.unauthorized }
        let token = try await postToken([
            .init(name: "grant_type", value: "refresh_token"),
            .init(name: "refresh_token", value: refreshToken),
            .init(name: "client_id", value: config.clientId)
        ])
        apply(token)
        return accessToken
    }
    
    // Updates the actor's internal state with fresh token data
    private func apply(_ token: TokenRefreshResponseDTO) {
        accessToken = token.access_token
        expiryDate = Date().advanced(by: TimeInterval(token.expires_in))
        
        if let newRefresh = token.refresh_token, !newRefresh.isEmpty {
            refreshToken = accessToken
            try? tokenStore.save(refreshToken: newRefresh)
        }
    }
    
    // The underlying networking engine that communicates with the token endpoint and decodes it into a DTO
    private func postToken(_ items: [URLQueryItem]) async throws -> TokenRefreshResponseDTO {
        guard let url = URL(string: "https://accounts.spotify.com/api/token") else {
            throw AppErrorEnum.networkError
        }
        var components = URLComponents()
        components.queryItems = items
        let body = components.percentEncodedQuery ?? ""

        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        req.httpBody = body.data(using: .utf8)

        let data: Data
        let response: URLResponse
        do { (data, response) = try await session.data(for: req) }
        catch { throw AppErrorEnum.networkError }

        guard let http = response as? HTTPURLResponse else { throw AppErrorEnum.networkError }
        switch http.statusCode {
        case 200...299: break
        case 400, 401:  throw AppErrorEnum.unauthorized   // bad/expired code or refresh token
        case 429:       throw AppErrorEnum.rateLimited
        case 500...599: throw AppErrorEnum.serverError(code: http.statusCode)
        default:        throw AppErrorEnum.serverError(code: http.statusCode)
        }

        do {
            return try decoder.decode(TokenRefreshResponseDTO.self, from: data)
        } catch {
            throw AppErrorEnum.decodingError
        }
    }
}
