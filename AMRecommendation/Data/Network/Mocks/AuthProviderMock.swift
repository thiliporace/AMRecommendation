//
//  AuthProviderMock.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 01/07/26.
//

import Foundation

class AuthProviderMock: AuthProviderProtocol, @unchecked Sendable {
    var token: String
    var errorToThrow: Error?
    
    private(set) var validAccessTokenCallCount = 0
    private(set) var forceRefreshCallCount = 0
    private(set) var exchangeCallCount = 0
    private(set) var lastExchange: (code: String, verifier: String)?
    
    init(token: String = "test-token", errorToThrow: Error? = nil) {
        self.token = token
        self.errorToThrow = errorToThrow
    }
    
    func validAccessToken() async throws -> String {
        validAccessTokenCallCount += 1
        if let errorToThrow { throw errorToThrow }
        return token
    }
    
    func refresh() async throws -> String {
        forceRefreshCallCount += 1
        if let errorToThrow { throw errorToThrow }
        return token
    }
    
    func exchange(code: String, verifier: String) async throws {
        exchangeCallCount += 1
        lastExchange = (code, verifier)
        if let errorToThrow { throw errorToThrow }
    }
    
    var isAuthenticated: Bool {
        return !token.isEmpty
    }
    
    func logout() async throws {
        token = ""
    }
}
