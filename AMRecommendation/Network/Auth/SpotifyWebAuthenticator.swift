//
//  SpotifyWebAuthenticator.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 03/07/26.
//

import Foundation
import AuthenticationServices

// Apple’s ASWebAuthenticationSession requires UI-driven interaction.
// By creating this Protocol, we avoid this requirement for Mock classes, so login() is testable.
protocol WebAuthenticationProtocol: Sendable {
    func authenticate(url: URL, callbackScheme: String?) async throws -> URL
}

// NSObject: Root class of almost all Objective C classes.
// @MainActor: Specifies that this class will run on the MainActor
@MainActor
final class SpotifyWebAuthenticator: NSObject, WebAuthenticationProtocol {
    
    func authenticate(url: URL, callbackScheme: String?) async throws -> URL {
        // Hold the session for the lifetime of the await, or ARC deallocates it
        var session: ASWebAuthenticationSession?
        
        return try await withCheckedThrowingContinuation { continuation in
            var didResume = false
            let resume: (Result<URL, Error>) -> Void = { result in
                guard !didResume else { return }
                didResume = true
                continuation.resume(with: result)
            }

            let newSession = ASWebAuthenticationSession(url: url,callbackURLScheme: callbackScheme) { callbackURL, error in
                if let callbackURL {
                    resume(.success(callbackURL))
                } else if let error {
                    // User tapping Cancel surfaces as ASWebAuthenticationSessionError.canceledLogin.
                    resume(.failure(Self.map(error)))
                } else {
                    resume(.failure(AppErrorEnum.unauthorized))
                }
            }

            //newSession.presentationContextProvider = self
            // don't reuse a stale Spotify cookie
            newSession.prefersEphemeralWebBrowserSession = true

            session = newSession
            guard newSession.start() else {
                resume(.failure(AppErrorEnum.networkError))
                return
            }
            _ = session
        }
    }
    
    private nonisolated static func map(_ error: Error) -> AppErrorEnum {
        if let authError = error as? ASWebAuthenticationSessionError,
           authError.code == .canceledLogin {
            return .unauthorized   // treat an explicit cancel as "not signed in"
        }
        return .networkError
    }
}

//extension SpotifyWebAuthenticator: ASWebAuthenticationPresentationContextProviding {
//    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
//        UIApplication.shared.connectedScenes
//            .compactMap { $0 as? UIWindowScene }
//            .flatMap { $0.windows }
//            .first { $0.isKeyWindow } ?? ASPresentationAnchor(windowScene: )
//    }
//}
