//
//  TrackRepositoryImpl.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 30/06/26.
//

import Foundation

// This protocol will be responsible for defining the function calls related to Tracks data retrieval from the Spotify Web API. This lives inside the Domain Layer.
protocol TrackRepositoryProtocol {
    // https://developer.spotify.com/documentation/web-api/reference/get-users-top-artists-and-tracks
    func getUserTopTracks(time_range: TimeRangeEnum, limit: Int, offset: Int) async throws -> [TrackModel]

    // https://developer.spotify.com/documentation/web-api/reference/get-recently-played
    // limit: The maximum number of items to return. Default: 20. Minimum: 1. Maximum: 50.
    // after: A Unix timestamp in milliseconds. Returns all items after (but not including) this cursor position. If after is specified, before must not be specified.
    // before: A Unix timestamp in milliseconds. Returns all items before (but not including) this cursor position. If before is specified, after must not be specified.
    func getUserRecentlyPlayedTracks(limit: Int, after: Int?, before: Int?) async throws -> [TrackModel]
}

class TrackRepositoryImpl: TrackRepositoryProtocol {
    
    let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func getUserTopTracks(time_range: TimeRangeEnum, limit: Int, offset: Int) async throws -> [TrackModel] {
        let page : PagingResponseDTO<TrackModelDTO> = try await apiClient.request(
            path: "/me/top/tracks", queryItems: [.init(name: "time_range", value: time_range.rawValue),
                                                 .init(name: "limit", value: String(limit)),
                                                 .init(name: "offset", value: String(offset))])
        
        return page.items.map { TrackModel(from: $0)}
    }
    
    func getUserRecentlyPlayedTracks(limit: Int, after: Int?, before: Int?) async throws -> [TrackModel] {
        let page : CursorPagingResponseDTO<TrackModelDTO> = try await apiClient.request(
            path: "/me/player/recently-played", queryItems: [.init(name: "limit", value: String(limit)),
                                                 .init(name: "after", value: String(after ?? 0)),
                                                 .init(name: "before", value: String(before ?? 0))])
        
        return page.items.map { TrackModel(from: $0)}
    }
    
    
}
