//
//  PlayHistoryModel.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 24/06/26.
//

import Foundation

struct PlayHistoryModel {
    // The track the user listened to.
    let track: TrackModel
    // The date and time the track was played.
    let playedAt: String
    // The context the track was played from.
    let context: ContextModel
}
