//
//  ArtistRepositoryImpl.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 30/06/26.
//

import Foundation

class ArtistRepositoryImpl: ArtistRepository {
    let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func getUserTopArtists(time_range: TimeRangeEnum, limit: Int, offset: Int) async throws -> [ArtistModel] {
        let page: PagingResponseDTO<ArtistModelDTO> = try await apiClient
            .request(path: "/me/top/artists", queryItems: [.init(name: "time_range", value: time_range.rawValue),
                                                           .init(name: "limit", value: String(limit)),
                                                           .init(name: "offset", value: String(offset))], repositoryType: "Artists")
        
        return page.items.map {ArtistModel(from: $0)}
    }
    
    func getArtist(id: String) async throws -> ArtistModel {
        let dto: ArtistModelDTO = try await apiClient
            .request(path: "/artists/\(id)", queryItems: [], repositoryType: "Artists")
        
        return ArtistModel(from: dto)
    }
}
