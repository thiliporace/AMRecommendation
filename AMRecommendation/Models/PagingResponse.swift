//
//  PagingResponse.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 24/06/26.
//

import Foundation

// Generic domain wrapper for paginated Spotify responses.
// Used by top artists, top tracks, and artist albums.
struct PagingResponse<T> {
    let items: [T]
    let total: Int
    let next: String?
}

extension PagingResponse: Equatable where T: Equatable {}
