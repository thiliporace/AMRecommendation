//
//  TokenStoreMock.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 01/07/26.
//

import Foundation

// Class used for testing the TokenStore
final class KeichainTokenStoreMock: TokenStoreProtocol, @unchecked Sendable {
    // An NSLock object can be used to mediate access to an application’s global data
    // This lock ensures that if Thread A and Thread B try to read and write the token at the exact same millisecond, the app won't crash
    private let lock = NSLock()
    private var token: String?
    
    init(token: String? = nil) {
        self.token = token
    }
    
    func loadRefreshToken() -> String? {
        // For thread-safety, lock this function until we can copy the value
        // You could also do it like this:
        // lock.lock(); defer { lock.unlock() }; return token
        lock.lock()
        let currentToken = token
        lock.unlock()
        return currentToken
    }
    
    func save(refreshToken: String) throws {
        lock.lock();
        // Run after the function finishes, but before leaving this function
        defer { lock.unlock() };
        token = refreshToken
    }
    
    func clear() throws {
        lock.lock();
        defer { lock.unlock() };
        token = nil
    }
}
