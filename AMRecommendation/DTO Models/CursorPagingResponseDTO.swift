//
//  CursorPagingResponseDTO.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 24/06/26.
//

import Foundation

// Generic cursor-based paging wrapper following the `CursorBasedPagingObject` definition in the Spotify Web API.
// Used by GET /me/player/recently-played.
struct CursorPagingResponseDTO<T: Decodable>: Decodable {
    // A link to the Web API endpoint returning the full result of the request.
    let href: String
    // The maximum number of items in the response.
    let limit: Int
    // URL to the next page of items. null if none.
    let next: String?
    // The cursors used to find the next set of items.
    let cursors: CursorsModelDTO
    // The total number of items available. Not always present in cursor-based responses.
    let total: Int?
    // The requested content.
    let items: [T]
}
