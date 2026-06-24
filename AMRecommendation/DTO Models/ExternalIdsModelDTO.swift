//
//  ExternalIdsModel.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 24/06/26.
//

import Foundation

// This struct will strictly follow the `ExternalIdsObject` definition inside of Spotify Web API
struct ExternalIdsModelDTO : Decodable {
    // International Standard Recording Code
    let isrc: String
    // International Article Number
    let ean: String
    // Universal Product Code
    let upc: String
}
