//
//  ExternalUrlsModelDTO.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 24/06/26.
//

import Foundation

// This struct will strictly follow the `ExternalUrlsObject` definition inside of Spotify Web API
struct ExternalUrlsModelDTO: Decodable {
    // The Spotify URL for the object.
    let spotify: String
}
