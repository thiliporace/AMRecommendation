//
//  LoginViewModel.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 06/07/26.
//

import Foundation
import Combine

@MainActor
final class LoginViewModel {
    /// Reference to Domain layer use cases
    var authRepositoryImpl: AuthRepositoryImpl

    /// Weak reference to coordinator
    private weak var loginCoordinator: LoginCoordinator?

    /// CurrentValueSubject holds its latest value, so a late subscriber immediately gets the current state
    /// CurrentValueSubject: A subject that wraps a single value and publishes a new element whenever the value changes.
    private let loginStateSubject = CurrentValueSubject<LoginStateEnum, Never>(.idle)

    /// This is the public reader the ViewModel will reference.
    /// By calling .eraseToAnyPublisher(), you expose a read-only stream to the View.
    /// The View can subscribe to changes, but it cannot send new values into the pipeline.
    var loginState: AnyPublisher<LoginStateEnum, Never> { loginStateSubject.eraseToAnyPublisher() }

    init(loginCoordinator: LoginCoordinator) {
        self.loginCoordinator = loginCoordinator
        authRepositoryImpl = Self.makeAuthRepository()
    }

    private static func makeAuthRepository() -> AuthRepositoryImpl {
        let config = SpotifyConfig(clientId: "", redirectUri: "", scopes: [""])
        let tokenStore = KeychainTokenStore(service: "", account: "")
        let authProvider = SpotifyAuthProvider(tokenStore: tokenStore, config: config)
        return AuthRepositoryImpl(
            auth: authProvider,
            webAuth: SpotifyWebAuthenticator(),
            pkce: PKCEGenerator(),
            config: config
        )
    }

    func handleLoginUserTap() {
        Task {
            loginStateSubject.send(.loading)
            do {
                authRepositoryImpl = Self.makeAuthRepository()
                try await authRepositoryImpl.login()
                loginStateSubject.send(await authRepositoryImpl.isAuthenticated ? .success : .error)
            } catch {
                loginStateSubject.send(.error)
            }
        }
    }
}
