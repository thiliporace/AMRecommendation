//
//  APIClientMock.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 30/06/26.
//

import Foundation

final class APIClientMock : APIClientProtocol, @unchecked Sendable{
    
    // Raw JSON to decode, or an error to throw
    var result: Result<Data, Error>
    // Captured so tests can assert how the repository called us.
    private(set) var lastPath: String?
    private(set) var lastQueryItems: [URLQueryItem] = []
    
    init(result: Result<Data, Error>) {
        self.result = result
    }
    
    // Return existing DTO
    func request<T>(path: String, queryItems: [URLQueryItem], repositoryType: String) async throws -> T where T : Decodable {
        lastPath = path
        lastQueryItems = queryItems
        
        switch result {
        case .success(let value):
            do{
                return try JSONDecoder().decode(T.self, from: value)
            } catch {
                throw AppErrorEnum.decodingError(repositoryType: repositoryType)
            }
        case .failure(let error):
            throw error
        }
    }
    
    func refreshToken() async throws {}
    
    
}
