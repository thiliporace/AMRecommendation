//
//  AlbumRepositoryImpl.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 30/06/26.
//

import Foundation

// This protocol will be responsible for defining the function calls related to Album data retrieval from the Spotify Web API. This lives inside the Domain Layer.
protocol AlbumRepositoryProtocol {
    // https://developer.spotify.com/documentation/web-api/reference/get-an-artists-albums
    func getArtistAlbums(id: String, include_groups: [AlbumGroupEnum], market: MarketEnum, limit: Int, offset: Int) async throws -> [SimplifiedAlbumModel]
}

class AlbumRepositoryImpl: AlbumRepositoryProtocol {
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
                                              .init(name: "offset", value: String(offset))])
        
        return page.items.map {SimplifiedAlbumModel(from: $0)}
    }
}
