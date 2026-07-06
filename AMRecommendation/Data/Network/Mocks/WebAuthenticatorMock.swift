//
//  WebAuthenticatorMock.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 03/07/26.
//

import Foundation

final class WebAuthenticatorMock: WebAuthenticationProtocol, @unchecked Sendable {
    
    var result: Result<URL, Error>

    private(set) var lastURL: URL?
    private(set) var lastCallbackScheme: String?
    private(set) var callCount = 0

    init(returningCode code: String = "returningCode", scheme: String = "amrecommendation", errorToThrow: Error? = nil) {
        if let errorToThrow {
            self.result = .failure(errorToThrow)
        } else {
            self.result = .success(URL(string: "\(scheme)://callback?code=\(code)")!)
        }
    }
    
    init(result: Result<URL, Error>) {
        self.result = result
    }

    func authenticate(url: URL, callbackScheme: String?) async throws -> URL {
        callCount += 1
        lastURL = url
        lastCallbackScheme = callbackScheme
        return try result.get()
    }
}
