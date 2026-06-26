//
//  SpotifyErrorDTO.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 25/06/26.
//

import Foundation

// Represents the root JSON error object
struct SpotifyErrorDTO: Decodable {
    let error: SpotifyErrorDetailDTO
}

// Represents the inner error details
struct SpotifyErrorDetailDTO: Decodable {
    let status: Int
    let message: String
}
