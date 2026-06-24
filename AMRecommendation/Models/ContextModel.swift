//
//  ContextModel.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 24/06/26.
//

import Foundation

struct ContextModel {
    // The object type, e.g. "artist", "playlist", "album", "show".
    let type: String
    // A link to the Web API endpoint providing full details of the context.
    let href: String
    // The Spotify URL for the context.
    let externalUrl: String
    // The Spotify URI for the context.
    let uri: String
}
