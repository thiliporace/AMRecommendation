//
//  CursorsModelDTO.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 24/06/26.
//

import Foundation

// This struct will strictly follow the `CursorsObject` definition inside of Spotify Web API
struct CursorsModelDTO: Decodable {
    // The cursor to use as key to find the next page of items.
    let after: String?
    // The cursor to use as key to find the previous page of items.
    let before: String?
}
