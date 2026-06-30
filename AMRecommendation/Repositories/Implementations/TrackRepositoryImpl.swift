//
//  TrackRepositoryImpl.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 30/06/26.
//

import Foundation

class TrackRepositoryImpl: TrackRepository {
    
    let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func getUserTopTracks(time_range: TimeRangeEnum, limit: Int, offset: Int) async throws -> [TrackModel] {
        let page : PagingResponseDTO<TrackModelDTO> = try await apiClient.request(
            path: "/me/top/tracks", queryItems: [.init(name: "time_range", value: time_range.rawValue),
                                                 .init(name: "limit", value: String(limit)),
                                                 .init(name: "offset", value: String(offset))], repositoryType: "Tracks")
        
        return page.items.map { TrackModel(from: $0)}
    }
    
    func getUserRecentlyPlayedTracks(limit: Int, after: Int?, before: Int?) async throws -> [TrackModel] {
        let page : CursorPagingResponseDTO<TrackModelDTO> = try await apiClient.request(
            path: "/me/player/recently-played", queryItems: [.init(name: "limit", value: String(limit)),
                                                 .init(name: "after", value: String(after ?? 0)),
                                                 .init(name: "before", value: String(before ?? 0))], repositoryType: "Tracks")
        
        return page.items.map { TrackModel(from: $0)}
    }
    
    
}
