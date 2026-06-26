//
//  NetworkSessionMock.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 26/06/26.
//

import Foundation

// final class: A class that cannot be subclassed or inherited by any other class
// nonisolated: Opts out of the MainActor default
// @unchecked: Nonisolated class with mutable vars can't satisfy checked Sendable
nonisolated final class NetworkSessionMock: NetworkSession, @unchecked Sendable {
    // Stubbing
    var data: Data
    var statusCode: Int
    var errorToThrow: Error?

    init(statusCode: Int = 200, data: Data = Data(), errorToThrow: Error? = nil) {
        self.data = data
        self.statusCode = statusCode
        self.errorToThrow = errorToThrow
    }

    // private(set): Public (or internal) read access but a private write access
    // Mocking
    private(set) var lastRequest: URLRequest?
    private(set) var requestCount = 0

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        lastRequest = request
        requestCount += 1

        if let errorToThrow { throw errorToThrow }

        guard let url = request.url else {
            print("request.url is nil")
            return (Data(), URLResponse())
        }

        let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)

        guard let response = response else {
            print("response is nil")
            return (Data(), URLResponse())
        }

        return (data, response)
    }
}
