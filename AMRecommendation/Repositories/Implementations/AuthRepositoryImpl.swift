//
//  AuthRepositoryImpl.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 01/07/26.
//

import Foundation

// This protocol will be responsible for defining the function calls related to Spotify Authentication.
// This lives in the Domain Layer, serving as an entry point for view model or coordinator calls.
protocol AuthRepositoryProtocol {
    func login() async throws
    func logout() async throws
    var isAuthenticated: Bool { get async }
}

// This class will be responsible for handling the User login that will be called in the Presentation Layer
final class AuthRepositoryImpl: AuthRepositoryProtocol {
    private let auth: AuthProviderProtocol
    private let webAuth: WebAuthenticationProtocol
    private let pkce: PKCEGenerator
    private let config: SpotifyConfig
    
    init(auth: AuthProviderProtocol, webAuth: WebAuthenticationProtocol, pkce: PKCEGenerator, config: SpotifyConfig) {
        self.auth = auth
        self.webAuth = webAuth
        self.pkce = pkce
        self.config = config
    }
    
    func login() async throws {
        let verifier = pkce.makeCodeVerifier()
        let challenge = pkce.makeCodeChallenge(for: verifier)
        
        let authUrl = try buildAuthorizeURL(challenge: challenge)
        let urlScheme = URL(string: config.redirectUri)?.scheme
        let callback = try await webAuth.authenticate(url: authUrl, callbackScheme: urlScheme)
        
        let code = try extractCode(from: callback)
        try await auth.exchange(code: code, verifier: verifier)
    }
    
    func logout() async throws {
        try await auth.logout()
    }
    
    private func buildAuthorizeURL(challenge: String) throws -> URL {
        var comps = URLComponents(string: "https://accounts.spotify.com/authorize")
        comps?.queryItems = [
            .init(name: "client_id", value: config.clientId),
            .init(name: "response_type", value: "code"),
            .init(name: "redirect_uri", value: config.redirectUri),
            .init(name: "scope", value: config.scopes.joined(separator: " ")),
            .init(name: "code_challenge_method", value: "S256"),
            .init(name: "code_challenge", value: challenge)
        ]
        guard let url = comps?.url else { throw AppErrorEnum.networkError }
        return url
    }
    
    private func extractCode(from url: URL) throws -> String {
        guard let code = URLComponents(url: url, resolvingAgainstBaseURL: false)?
            .queryItems?.first(where: { $0.name == "code" })?.value,
              !code.isEmpty
        else { throw AppErrorEnum.unauthorized }
        return code
    }
    
    var isAuthenticated: Bool { get async { await auth.isAuthenticated }}
}
