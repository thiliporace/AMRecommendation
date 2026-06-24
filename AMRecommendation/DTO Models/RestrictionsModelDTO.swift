//
//  RestrictionsModelDTO.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 24/06/26.
//

import Foundation

// This struct will strictly follow the `RestrictionsObject` definition inside of Spotify Web API
struct RestrictionsModelDTO: Decodable {
    //The reason for the restriction. Albums may be restricted if the content is not available in a given market, to the user's subscription type, or when the user's account is set to not play explicit content. Additional reasons may be added in the future.
    let reason: String?
}
