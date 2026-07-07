//
//  APIClient.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 25/06/26.
//

import Foundation

// Required for Unit Testing repository implementations.
// Sendable: a protocol that indicates a type is safe to share across concurrent contexts
// (like between different threads, tasks, or actors) without causing data races
protocol APIClientProtocol: Sendable {
    // <T>: Generics - The repository implementation that calls this function will tell what type this function will return
    // : Decodable - The type returned by this function MUST conform to Decodable
    func request<T: Decodable>(path: String, queryItems: [URLQueryItem]) async throws -> T
}

extension APIClientProtocol {
    // Overload request function that does not require `queryItems`, needed for endpoints like getArtist(id:)
    func request<T: Decodable>(path: String) async throws -> T {
        try await request(path: path, queryItems: [])
    }
}

actor APIClient: APIClientProtocol {
    private let baseURL = URL(string: "https://api.spotify.com/v1")
    private let session: NetworkSessionProtocol
    private let decoder: JSONDecoder
    private let auth: AuthProviderProtocol

    init(session: NetworkSessionProtocol = URLSession.shared, auth: AuthProviderProtocol) {
        self.session = session
        self.decoder = JSONDecoder()
        self.auth = auth
    }

    func request<T: Sendable>(path: String, queryItems: [URLQueryItem]) async throws -> T where T: Decodable {
        // 1 - Build the URL - URLComponents handles encoding of your query values
        guard let baseURL = baseURL else {
            throw AppErrorEnum.networkError
        }

        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        guard var components = components else {
            throw AppErrorEnum.networkError
        }

        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }

        guard let url = components.url else {
            throw AppErrorEnum.networkError
        }
        
        var token = try await auth.validAccessToken()

        // 2 - Build the request with the owner token. Every Spotify request needs the Authorization: Bearer <token>
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        // 3 - Send the request
        let data: Data
        let response: URLResponse
        do {
            // When session.data finally finishes, it returns a Tuple, data (JSON bytes) and response (URLResponse)
            (data, response) = try await session.data(for: urlRequest)
        } catch {
            throw AppErrorEnum.networkError
        }

        // 4 - Map status codes to AppError enum
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AppErrorEnum.networkError
        }

        switch httpResponse.statusCode {
        case 200...299:
            break // success, go ahead to decoding
        case 401:
            throw AppErrorEnum.unauthorized
        case 403:
            throw AppErrorEnum.forbidden
        case 429:
            throw AppErrorEnum.rateLimited
        case 500...599:
            throw AppErrorEnum.serverError(code: httpResponse.statusCode)
        default:
            throw AppErrorEnum.serverError(code: httpResponse.statusCode)
        }

        // 5 - Decode the data
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw AppErrorEnum.decodingError
        }
    }
}
