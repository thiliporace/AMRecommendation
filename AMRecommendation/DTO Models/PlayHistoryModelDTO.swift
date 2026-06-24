//
//  PlayHistoryModelDTO.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 24/06/26.
//

import Foundation

// This struct will strictly follow the `PlayHistoryObject` definition inside of Spotify Web API
struct PlayHistoryModelDTO: Decodable {
    // The track the user listened to.
    let track: TrackModelDTO
    // The date and time the track was played.
    let played_at: String
    // The context the track was played from.
    let context: ContextModelDTO
}
