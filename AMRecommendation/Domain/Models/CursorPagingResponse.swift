//
//  CursorPagingResponse.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 24/06/26.
//

import Foundation

// Generic domain wrapper for cursor-based paginated Spotify responses.
// Used by recently played history.
struct CursorPagingResponse<T> {
    let items: [T]
    let next: String?
}

extension CursorPagingResponse: Equatable where T: Equatable {}
