//
//  ImageModel.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 24/06/26.
//

import Foundation

struct ImageModel : Equatable {
    // The source URL of the image.
    let url: String
    // The image height in pixels. Nullable.
    let height: Int?
    // The image width in pixels. Nullable.
    let width: Int?
    
    static func == (lhs: ImageModel, rhs: ImageModel) -> Bool {
        return lhs.url == rhs.url // Only check the URL
    }
}
