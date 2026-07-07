//
//  TrackModelDTO.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 24/06/26.
//

import Foundation

// This struct will strictly follow the `TrackObject` definition inside of Spotify Web API
struct TrackModelDTO: Decodable {
    // The album on which the track appears. The album object includes a link in href to full information about the album.
    let album: AlbumModelDTO
    // The artists who performed the track. Each artist object includes a link in href to more detailed information about the artist.
    let artists: [SimplifiedArtistModelDTO]
    // The disc number (usually 1 unless the album consists of more than one disc).
    let disc_number: Int
    // The track length in milliseconds.
    let duration_ms: Int
    // Whether or not the track has explicit lyrics ( true = yes it does; false = no it does not OR unknown).
    let explicit: Bool
    // Known external IDs for the track.
    let external_ids: ExternalIdsModelDTO
    // Known external URLs for this track.
    let external_urls: ExternalUrlsModelDTO
    // A link to the Web API endpoint providing full details of the track.
    let href: String
    // The Spotify ID for the track.
    let id: String
    // Part of the response when Track Relinking is applied. If true, the track is playable in the given market.
    let is_playable: Bool?
    // Included in the response when a content restriction is applied.
    let restrictions: RestrictionsModelDTO?
    // The name of the track.
    let name: String
    // The number of the track. If an album has several discs, the track number is the number on the specified disc.
    let track_number: Int
    // The object type: "track".
    let type: String
    // The Spotify URI for the track.
    let uri: String
    // Whether or not the track is from a local file.
    let is_local: Bool
}
