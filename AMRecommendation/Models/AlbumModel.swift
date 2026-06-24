//
//  AlbumModel.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 24/06/26.
//

import Foundation

struct AlbumModel {
    // The type of the album.
    let albumType: String
    // The number of tracks in the album.
    let totalTracks: Int
    // Known external URLs for this album. Only Spotify string needs to be filled.
    let externalUrl: String
    // A link to the Web API endpoint providing full details of the album.
    let href: String
    // The Spotify ID for the album.
    let id: String
    // The cover art for the album in various sizes, widest first.
    let images: [ImageModel]
    // The name of the album. In case of an album takedown, the value may be an empty string.
    let name: String?
    // The date the album was first released.
    let releaseDate: String
    // The precision with which release_date value is known. Allowed values: "year", "month", "day"
    let releaseDatePrecision: String
    // The reason for the restriction. Albums may be restricted if the content is not available in a given market, to the user's subscription type, or when the user's account is set to not play explicit content. Additional reasons may be added in the future.
    let restrictionReason: String
    // The object type.
    let type: String
    // The Spotify URI for the album.
    let uri: String
    // The artists of the album. Each artist object includes a link in href to more detailed information about the artist.
    let artists: [SimplifiedArtistModel]
}
