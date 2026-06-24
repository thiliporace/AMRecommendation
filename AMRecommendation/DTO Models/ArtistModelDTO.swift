//
//  ArtistModelDTO.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 24/06/26.
//

import Foundation

// This struct will strictly follow the `ArtistObject` definition inside of Spotify Web API
struct ArtistModelDTO: Decodable {
    // Known external URLs for this artist.
    let external_urls: ExternalUrlsModelDTO
    // A link to the Web API endpoint providing full details of the artist.
    let href: String
    // The Spotify ID for the artist.
    let id: String
    // Images of the artist in various sizes, widest first.
    let images: [ImageModelDTO]
    // The name of the artist.
    let name: String
    // The object type.
    let type: String
    // The Spotify URI for the artist.
    let uri: String
}
