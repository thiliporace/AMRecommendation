//
//  ImageModel.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 24/06/26.
//

import Foundation

// This struct will strictly follow the `ImageObject` definition inside of Spotify Web API
struct ImageModelDTO: Decodable {
    // The source URL of the image.
    let url: String
    // The image height in pixels. Nullable.
    let height: Int?
    // The image width in pixels. Nullable.
    let width: Int?
}
