//
//  ExternalIdsModel.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 24/06/26.
//

import Foundation

struct ExternalIdsModel: Equatable {
    // International Standard Recording Code
    let isrc: String?
    // International Article Number
    let ean: String?
    // Universal Product Code
    let upc: String?
}
