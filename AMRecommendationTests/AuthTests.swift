//
//  AuthTests.swift
//  AMRecommendationTests
//
//  Created by Thiago Liporace on 01/07/26.
//

import Foundation
import Testing
@testable import AMRecommendation

// MARK: Common functions used by all Test Suites

private func createAuthRepositoryImpl
(auth: AuthProviderProtocol = AuthProviderMock(), webAuth: WebAuthenticationProtocol = WebAuthenticatorMock()) -> AuthRepositoryImpl {
    let clientId = "test-client-id"
    let redirectUri = "amrecommendation://callback"
    let scopes = ["user-top-read","user-read-recently-played"]

    let spotifyConfig = SpotifyConfig(clientId: clientId, redirectUri: redirectUri, scopes: scopes)
    return AuthRepositoryImpl(auth: auth, webAuth: webAuth, pkce: PKCEGenerator(), config: spotifyConfig)
}

private func queryValue(_ url: URL, _ name: String) -> String? {
    URLComponents(url: url, resolvingAgainstBaseURL: false)?
        .queryItems?.first { $0.name == name }?.value
}

// MARK: AuthRepositoryImpl

@Suite("AuthRepositoryImpl - login, logout, isAuthenticated")
struct AuthRepositoryImplTests {
    
    @Test("login builds a correct /authorize URL with all PKCE params")
        func loginBuildsAuthorizeURL() async throws {
        let webAuth = WebAuthenticatorMock()
        let repo = createAuthRepositoryImpl(webAuth: webAuth)

        try await repo.login()

        let url = try #require(webAuth.lastURL)
        #expect(url.absoluteString.contains("accounts.spotify.com/authorize"))
        #expect(queryValue(url, "client_id") == "test-client-id")
        #expect(queryValue(url, "response_type") == "code")
        #expect(queryValue(url, "redirect_uri") == "amrecommendation://callback")
        #expect(queryValue(url, "scope") == "user-top-read user-read-recently-played")
        #expect(queryValue(url, "code_challenge_method") == "S256")
        // Challenge is generated fresh; we only assert it's present and non-empty.
        #expect(queryValue(url, "code_challenge")?.isEmpty == false)
    }
    
    @Test("login passes the redirect URI's scheme as the callback scheme")
    func loginPassesCallbackScheme() async throws {
        let webAuth = WebAuthenticatorMock()
        let repo = createAuthRepositoryImpl(webAuth: webAuth)

        try await repo.login()

        #expect(webAuth.lastCallbackScheme == "amrecommendation")
        #expect(webAuth.callCount == 1)
    }
    
    @Test("login extracts the code from the callback and forwards it to exchange")
    func loginExtractsCodeAndExchanges() async throws {
        let webAuth = WebAuthenticatorMock(returningCode: "abc123")
        let authMock = AuthProviderMock()
        let repo = createAuthRepositoryImpl(auth: authMock, webAuth: webAuth)

        try await repo.login()

        #expect(authMock.exchangeCallCount == 1)
        #expect(authMock.lastExchange?.code == "abc123")
        // The verifier handed to exchange must be the same one hashed into the challenge —
        // it's non-empty and it is NOT the challenge that went into the URL.
        let verifier = try #require(authMock.lastExchange?.verifier)
        #expect(!verifier.isEmpty)
        #expect(verifier != queryValue(webAuth.lastURL!, "code_challenge"))
    }
    
    @Test("login propagates a web-auth error (e.g. user cancel) and never exchanges")
    func loginPropagatesWebAuthError() async throws {
        let webAuth = WebAuthenticatorMock(errorToThrow: AppErrorEnum.unauthorized)
        let authMock = AuthProviderMock()
        let repo = createAuthRepositoryImpl(auth: authMock, webAuth: webAuth)

        await #expect(throws: AppErrorEnum.unauthorized) {
            try await repo.login()
        }
        #expect(authMock.exchangeCallCount == 0)
    }
    
    @Test("login throws .unauthorized when the callback carries no code")
    func loginThrowsWhenNoCode() async throws {
        let noCodeURL = URL(string: "amrecommendation://callback")!
        let webAuth = WebAuthenticatorMock(result: .success(noCodeURL))
        let authMock = AuthProviderMock()
        let repo = createAuthRepositoryImpl(auth: authMock, webAuth: webAuth)

        await #expect(throws: AppErrorEnum.unauthorized) {
            try await repo.login()
        }
        #expect(authMock.exchangeCallCount == 0)
    }
    
    @Test("login propagates an error thrown by exchange")
    func loginPropagatesExchangeError() async throws {
        let webAuth = WebAuthenticatorMock()
        let authMock = AuthProviderMock(errorToThrow: AppErrorEnum.rateLimited)
        let repo = createAuthRepositoryImpl(auth: authMock, webAuth: webAuth)

        await #expect(throws: AppErrorEnum.rateLimited) {
            try await repo.login()
        }
    }
    
    @Test("logout delegates to the provider")
    func logoutDelegates() async throws {
        let authMock = AuthProviderMock()
        let repo = createAuthRepositoryImpl(auth: authMock)

        #expect(await repo.isAuthenticated == true)   // starts with a token
        try await repo.logout()
        #expect(await repo.isAuthenticated == false)  // provider cleared it
    }
    
    @Test("isAuthenticated reflects the provider state")
    func isAuthenticatedReflectsProvider() async throws {
        let signedOut = AuthProviderMock(token: "")
        let repo = createAuthRepositoryImpl(auth: signedOut)
        #expect(await repo.isAuthenticated == false)
    }
}

// MARK: AuthProviderMock

@Suite("AuthProviderMock - token, errors")
struct AuthProviderMockTests {
    @Test("validAccessToken returns the token and counts the call")
    func validAccessToken() async throws {
        let mock = AuthProviderMock(token: "tok")
        let token = try await mock.validAccessToken()
        #expect(token == "tok")
        #expect(mock.validAccessTokenCallCount == 1)
    }
    
    @Test("validAccessToken throws the injected error")
    func validAccessTokenThrows() async throws {
        let mock = AuthProviderMock(errorToThrow: AppErrorEnum.unauthorized)
        await #expect(throws: AppErrorEnum.unauthorized) { _ = try await mock.validAccessToken() }
    }
    
    @Test("refresh returns the token and counts the call")
    func refresh() async throws {
        let mock = AuthProviderMock(token: "tok")
        let token = try await mock.refresh()
        #expect(token == "tok")
        #expect(mock.forceRefreshCallCount == 1)
    }
    
    @Test("refresh throws the injected error")
    func refreshThrows() async throws {
        let mock = AuthProviderMock(errorToThrow: AppErrorEnum.rateLimited)
        await #expect(throws: AppErrorEnum.rateLimited) { _ = try await mock.refresh() }
    }
    
    @Test("exchange records its arguments and counts the call")
    func exchange() async throws {
        let mock = AuthProviderMock()
        try await mock.exchange(code: "c", verifier: "v")
        #expect(mock.exchangeCallCount == 1)
        #expect(mock.lastExchange?.code == "c")
        #expect(mock.lastExchange?.verifier == "v")
    }
    
    @Test("exchange throws the injected error")
    func exchangeThrows() async throws {
        let mock = AuthProviderMock(errorToThrow: AppErrorEnum.decodingError)
        await #expect(throws: AppErrorEnum.decodingError) {
            try await mock.exchange(code: "c", verifier: "v")
        }
    }
    
    @Test("isAuthenticated flips to false after logout")
    func isAuthenticatedAfterLogout() async throws {
        let mock = AuthProviderMock(token: "tok")
        #expect(mock.isAuthenticated == true)
        try await mock.logout()
        #expect(mock.isAuthenticated == false)
    }
}

// MARK: KeichanTokenStoreMock

@Suite("TokenStoreMock - token")
struct TokenStoreMockTests {
    @Test("load returns nil before anything is saved")
    func loadNilInitially() {
        #expect(KeichainTokenStoreMock().loadRefreshToken() == nil)
    }

    @Test("init seed is readable")
    func initWithSeed() {
        #expect(KeichainTokenStoreMock(token: "seed").loadRefreshToken() == "seed")
    }

    @Test("save then load round-trips")
    func saveThenLoad() throws {
        let store = KeichainTokenStoreMock()
        try store.save(refreshToken: "r1")
        #expect(store.loadRefreshToken() == "r1")
    }

    @Test("save overwrites (last write wins)")
    func saveOverwrites() throws {
        let store = KeichainTokenStoreMock(token: "old")
        try store.save(refreshToken: "new")
        #expect(store.loadRefreshToken() == "new")
    }

    @Test("clear removes the token")
    func clearRemoves() throws {
        let store = KeichainTokenStoreMock(token: "r1")
        try store.clear()
        #expect(store.loadRefreshToken() == nil)
    }
}

// MARK: WebAuthenticatorMock

@Suite("WebAuthenticatorMock - authenticate")
struct WebAuthenticatorMockTests {
    @Test("authenticate returns the callback URL and records its inputs")
    func authenticateRecords() async throws {
        let mock = WebAuthenticatorMock(returningCode: "xyz")
        let requested = URL(string: "https://accounts.spotify.com/authorize?x=1")!

        let callback = try await mock.authenticate(url: requested, callbackScheme: "amrecommendation")

        #expect(queryValue(callback, "code") == "xyz")
        #expect(mock.lastURL == requested)
        #expect(mock.lastCallbackScheme == "amrecommendation")
        #expect(mock.callCount == 1)
    }

    @Test("authenticate throws when constructed with an error")
    func authenticateThrows() async throws {
        let mock = WebAuthenticatorMock(errorToThrow: AppErrorEnum.unauthorized)
        await #expect(throws: AppErrorEnum.unauthorized) {
            _ = try await mock.authenticate(url: URL(string: "https://x")!, callbackScheme: nil)
        }
    }

    @Test("the Result initializer injects an arbitrary URL")
    func resultInit() async throws {
        let custom = URL(string: "amrecommendation://callback?code=fromResult")!
        let mock = WebAuthenticatorMock(result: .success(custom))
        let out = try await mock.authenticate(url: URL(string: "https://x")!, callbackScheme: nil)
        #expect(out == custom)
    }
}

// MARK: SpotifyConfig

@Suite("SpotifyConfig")
struct SpotifyConfigTests {
    @Test("memberwise init stores its values")
    func memberwiseInit() {
        let config = SpotifyConfig(clientId: "id", redirectUri: "scheme://cb", scopes: ["a", "b"])
        #expect(config.clientId == "id")
        #expect(config.redirectUri == "scheme://cb")
        #expect(config.scopes == ["a", "b"])
    }

    // fromBundle depends on Info.plist (and thus a host app). Assert the contract holds
    // either way, so the test is stable regardless of the target's host-app setting.
    @Test("fromBundle returns non-empty values or throws .accessTokenMissing")
    func fromBundleContract() {
        do {
            let config = try SpotifyConfig.fromBundle()
            #expect(!config.clientId.isEmpty)
            #expect(!config.redirectUri.isEmpty)
            #expect(config.scopes == ["user-top-read", "user-read-recently-played"])
        } catch {
            #expect(error as? AppErrorEnum == .accessTokenMissing)
        }
    }
}
