//
//  AlbumModelDTO.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 24/06/26.
//

import Foundation

// This struct will strictly follow the `AlbumObject` definition inside of Spotify Web API
struct AlbumModelDTO: Decodable {
    // The type of the album. Allowed values: "album", "single", "compilation"
    let album_type: String
    // The number of tracks in the album.
    let total_tracks: Int
    // Known external URLs for this album.
    let external_urls: ExternalUrlsModelDTO
    // A link to the Web API endpoint providing full details of the album.
    let href: String
    // The Spotify ID for the album.
    let id: String
    // The cover art for the album in various sizes, widest first.
    let images: [ImageModelDTO]
    // The name of the album. In case of an album takedown, the value may be an empty string.
    let name: String?
    // The date the album was first released.
    let release_date: String
    // The precision with which release_date value is known. Allowed values: "year", "month", "day"
    let release_date_precision: String
    // Included in the response when a content restriction is applied.
    let restrictions: RestrictionsModelDTO?
    // The object type. Allowed values: "album"
    let type: String
    // The Spotify URI for the album.
    let uri: String
    // The artists of the album.
    let artists: [SimplifiedArtistModelDTO]
}
