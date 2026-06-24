//
//  ContextModelDTO.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 24/06/26.
//

import Foundation

// This struct is similar to the `ContextObject` found on the Spotify Web API
struct ContextModelDTO: Decodable {
    // The object type, e.g. "artist", "playlist", "album", "show".
    let type: String
    // A link to the Web API endpoint providing full details of the track.
    let href: String
    // External URLs for this context.
    let external_urls: ExternalUrlsModelDTO
    // The Spotify URI for the context.
    let uri: String
}
