//
//  AlbumRepository.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 25/06/26.
//

import Foundation

// This protocol will be responsible for defining the function calls related to Album data retrieval from the Spotify Web API. This lives inside the Domain Layer.
protocol AlbumRepository {
    // https://developer.spotify.com/documentation/web-api/reference/get-an-artists-albums
    func getArtistAlbums(id: String, include_groups: AlbumGroupEnum, market: MarketEnum, limit: Int, offset: Int) async throws -> [SimplifiedAlbumModel]
}
