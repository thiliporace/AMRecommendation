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
        authRepositoryImpl = AuthRepositoryImpl(auth: SpotifyAuthProvider(tokenStore: KeychainTokenStore(service: "", account: ""), config: SpotifyConfig(clientId: "", redirectUri: "", scopes: [""])), webAuth: SpotifyWebAuthenticator(), pkce: PKCEGenerator(), config: SpotifyConfig(clientId: "", redirectUri: "", scopes: [""]))
    }
    
    func handleLoginUserTap(){
        Task{
            do {
                onLoginStateChange?(.loading)
                
                authRepositoryImpl = AuthRepositoryImpl(auth: SpotifyAuthProvider(tokenStore: KeychainTokenStore(service: "", account: ""), config: SpotifyConfig(clientId: "", redirectUri: "", scopes: [""])), webAuth: SpotifyWebAuthenticator(), pkce: PKCEGenerator(), config: SpotifyConfig(clientId: "", redirectUri: "", scopes: [""]))
                
                try await authRepositoryImpl.login()
                
                let authorized: Bool
                await authorized = authRepositoryImpl.isAuthenticated
                
                if authorized { onLoginStateChange?(.success) }
                else { onLoginStateChange?(.error) }
            }
        }
    }
}
