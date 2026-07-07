//
//  LoginViewModel.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 06/07/26.
//

import Foundation

@MainActor
final class LoginViewModel {
    // Reference to Domain layer use cases
    var authRepositoryImpl: AuthRepositoryImpl
    
    // Weak reference to coordinator
    private weak var loginCoordinator: LoginCoordinator?
    
    // Delegate referenced by ViewController that listens to state change
    var onLoginStateChange: ((LoginStateEnum) -> Void)?
    
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

    func handleLoginUserTap(){
        Task{
            do {
                onLoginStateChange?(.loading)

                authRepositoryImpl = Self.makeAuthRepository()

                try await authRepositoryImpl.login()
                
                let authorized: Bool
                await authorized = authRepositoryImpl.isAuthenticated
                
                if authorized { onLoginStateChange?(.success) }
                else { onLoginStateChange?(.error) }
            }
        }
    }
}
