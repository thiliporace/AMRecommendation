//
//  AlbumRepositoryImpl.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 30/06/26.
//

import Foundation

class AlbumRepositoryImpl: AlbumRepository {
    let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    // Implement the real request to the APIClient
    func getArtistAlbums(id: String, include_groups: [AlbumGroupEnum], market: MarketEnum, limit: Int, offset: Int) async throws -> [SimplifiedAlbumModel] {
        let path: String = "/artists/\(id)/albums"
        let page: PagingResponseDTO<SimplifiedAlbumModelDTO> = try await apiClient
            .request(path: path, queryItems: [.init(name: "market", value: market.rawValue),
                                              .init(name: "include_groups", value: include_groups.asAPIQueryString()),
                                              .init(name: "limit", value: String(limit)),
                                              .init(name: "offset", value: String(offset))]
                                                , repositoryType: "AlbumRepository")
        
        return page.items.map {SimplifiedAlbumModel(from: $0)}
    }
}
