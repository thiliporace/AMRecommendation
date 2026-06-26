//
//  ArtistRepository.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 25/06/26.
//

import Foundation

// This protocol will be responsible for defining the function calls related to Artist data retrieval from the Spotify Web API. This lives inside the Domain Layer.
protocol ArtistRepository {
    // https://developer.spotify.com/documentation/web-api/reference/get-users-top-artists-and-tracks
    func getUserTopArtists(time_range: TimeRangeEnum, limit: Int, offset: Int) async throws -> [ArtistModel]
    
    // https://developer.spotify.com/documentation/web-api/reference/get-an-artist
    func getArtist(id: String) async throws -> ArtistModel
}
