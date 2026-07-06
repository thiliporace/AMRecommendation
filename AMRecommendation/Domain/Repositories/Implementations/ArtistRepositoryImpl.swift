//
//  ArtistRepositoryImpl.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 30/06/26.
//

import Foundation

// This protocol will be responsible for defining the function calls related to Artist data retrieval from the Spotify Web API. This lives inside the Domain Layer.
protocol ArtistRepositoryProtocol {
    // https://developer.spotify.com/documentation/web-api/reference/get-users-top-artists-and-tracks
    func getUserTopArtists(time_range: TimeRangeEnum, limit: Int, offset: Int) async throws -> [ArtistModel]

    // https://developer.spotify.com/documentation/web-api/reference/get-an-artist
    func getArtist(id: String) async throws -> ArtistModel
}

class ArtistRepositoryImpl: ArtistRepositoryProtocol {
    let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func getUserTopArtists(time_range: TimeRangeEnum, limit: Int, offset: Int) async throws -> [ArtistModel] {
        let page: PagingResponseDTO<ArtistModelDTO> = try await apiClient
            .request(path: "/me/top/artists", queryItems: [.init(name: "time_range", value: time_range.rawValue),
                                                           .init(name: "limit", value: String(limit)),
                                                           .init(name: "offset", value: String(offset))])
        
        return page.items.map {ArtistModel(from: $0)}
    }
    
    func getArtist(id: String) async throws -> ArtistModel {
        let dto: ArtistModelDTO = try await apiClient
            .request(path: "/artists/\(id)", queryItems: [])
        
        return ArtistModel(from: dto)
    }
}
