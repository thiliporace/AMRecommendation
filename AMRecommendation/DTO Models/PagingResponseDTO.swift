//
//  PagingResponseDTO.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 24/06/26.
//

import Foundation

// Generic paging wrapper following the `PagingObject` definition in the Spotify Web API.
// Used by GET /me/top/artists, GET /me/top/tracks, and GET /artists/{id}/albums.
struct PagingResponseDTO<T: Decodable & Sendable>: Decodable, Sendable {
    // A link to the Web API endpoint returning the full result of the request.
    let href: String
    // The maximum number of items in the response.
    let limit: Int
    // URL to the next page of items. null if none.
    let next: String?
    // The offset of the items returned.
    let offset: Int
    // URL to the previous page of items. null if none.
    let previous: String?
    // The total number of items available.
    let total: Int
    // The requested content.
    let items: [T]
}
