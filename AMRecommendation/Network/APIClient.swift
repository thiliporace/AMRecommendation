//
//  APIClient.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 25/06/26.
//

import Foundation

actor APIClient: APIClientProtocol {
    private let baseURL = URL(string: "https://api.spotify.com/v1")
    private let session: NetworkSession
    private let decoder: JSONDecoder
    private var accessToken: String

    private var expiryDate: Date
    private var refreshToken: String

    init(session: NetworkSession = URLSession.shared, accessToken: String) {
        self.session = session
        self.decoder = JSONDecoder()
        self.accessToken = accessToken
        self.expiryDate = Date().advanced(by: 3600) // Create expiry date for an hour after the first init
        self.refreshToken = ""
    }

    func request<T: Sendable>(path: String, queryItems: [URLQueryItem], repositoryType: String) async throws -> T where T: Decodable {
        // 1 - Build the URL - URLComponents handles encoding of your query values
        guard let baseURL = baseURL else {
            print("baseURL is nil")
            throw URLError(.unknown)
        }

        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        guard var components = components else {
            print("components is nil")
            throw URLError(.unknown)
        }

        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }

        guard let url = components.url else {
            throw AppErrorEnum.networkError(repositoryType: repositoryType)
        }

        // After an hour has passed, refresh the token
        if Date() >= expiryDate.addingTimeInterval(-60) {
            try await refreshToken()
        }

        // 2 - Build the request with the owner token. Every Spotify request needs the Authorization: Bearer <token>
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        // 3 - Send the request
        let data: Data
        let response: URLResponse
        do {
            // When session.data finally finishes, it returns a Tuple, data (JSON bytes) and response (URLResponse)
            (data, response) = try await session.data(for: urlRequest)
        } catch {
            throw AppErrorEnum.networkError(repositoryType: repositoryType)
        }

        // 4 - Map status codes to AppError enum
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AppErrorEnum.networkError(repositoryType: repositoryType)
        }

        switch httpResponse.statusCode {
        case 200...299:
            break // success, go ahead to decoding
        case 401:
            throw AppErrorEnum.unauthorized(repositoryType: repositoryType)
        case 403:
            throw AppErrorEnum.forbidden(repositoryType: repositoryType)
        case 429:
            throw AppErrorEnum.rateLimited(repositoryType: repositoryType)
        case 500...599:
            throw AppErrorEnum.serverError(repositoryType: repositoryType, code: httpResponse.statusCode)
        default:
            throw AppErrorEnum.serverError(repositoryType: repositoryType, code: httpResponse.statusCode)
        }

        // 5. Decode the data
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw AppErrorEnum.decodingError(repositoryType: repositoryType)
        }
    }

    func refreshToken() async throws {
        let repoName = "RefreshToken"
        let clientId = Bundle.main.infoDictionary?["SPOTIFY_CLIENT_ID"] as? String

        guard let clientId = clientId else {
            print("ClientId is nil")
            return
        }

        // 1 - Token Endpoint
        guard let url = URL(string: "https://accounts.spotify.com/api/token") else {
            throw AppErrorEnum.networkError(repositoryType: repoName)
        }

        // 2 - Refresh token
        var components = URLComponents()
        components.queryItems = [
            .init(name: "grant_type", value: "refresh_token"),
            .init(name: "refresh_token", value: refreshToken),
            .init(name: "client_id", value: clientId)
        ]

        let bodyString = components.percentEncodedQuery ?? ""

        var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = bodyString.data(using: .utf8)

        // 3 - Send
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch {
            throw AppErrorEnum.networkError(repositoryType: repoName)
        }

        // 4 - Status mapping. A 400/401 here usually means the refresh token itself is invalid, user must log in again.
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AppErrorEnum.networkError(repositoryType: repoName)
        }
        switch httpResponse.statusCode {
        case 200...299:
            break
        case 400, 401:
            // refresh token no longer valid — treat as session expired
            throw AppErrorEnum.unauthorized(repositoryType: repoName)
        case 429:
            throw AppErrorEnum.rateLimited(repositoryType: repoName)
        case 500...599:
            throw AppErrorEnum.serverError(repositoryType: repoName, code: httpResponse.statusCode)
        default:
            throw AppErrorEnum.serverError(repositoryType: repoName, code: httpResponse.statusCode)
        }

        // 5 - Decode and update state
        let tokenResponse: TokenRefreshResponseDTO
        do {
            tokenResponse = try decoder.decode(
                TokenRefreshResponseDTO.self, from: data
            )
        } catch {
            throw AppErrorEnum.decodingError(repositoryType: repoName)
        }

        // 6 - Mutate actor state. Safe: only one task is inside the actor.
        self.accessToken = tokenResponse.access_token
        self.expiryDate = Date().advanced(by: TimeInterval(tokenResponse.expires_in))
        if let newRefresh = tokenResponse.refresh_token {
            self.refreshToken = newRefresh
        }
    }
}
