//
//  APIClientProtocol.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 25/06/26.
//

import Foundation

// Required for Unit Testing repository implementations.
protocol APIClientProtocol: Sendable {
    // <T>: Generics - The repository implementation that calls this function will tell what type this function will return
    // : Decodable - The type returned by this function MUST conform to Decodable
    func request<T: Decodable>(
        path: String,
        queryItems: [URLQueryItem],
        repositoryType: String
    ) async throws -> T

    func refreshToken() async throws
}

extension APIClientProtocol {
    // Overload request function that does not require `queryItems`, needed for endpoints like getArtist(id:)
    func request<T: Decodable>(
        path: String,
        repositoryType: String
    ) async throws -> T {
        try await request(
            path: path,
            queryItems: [],
            repositoryType: repositoryType
        )
    }
}
