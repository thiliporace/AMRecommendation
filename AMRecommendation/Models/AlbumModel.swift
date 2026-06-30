//
//  AlbumModel.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 24/06/26.
//

import Foundation

struct AlbumModel: Equatable {
    // The type of the album. Possible values: "album", "single", "compilation"
    let albumType: String
    // The number of tracks in the album.
    let totalTracks: Int
    // The Spotify URL for the album.
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
    // The reason for the restriction, if any.
    let restrictionReason: String?
    // The object type.
    let type: String
    // The Spotify URI for the album.
    let uri: String
    // The artists of the album.
    let artists: [SimplifiedArtistModel]

    static func == (lhs: AlbumModel, rhs: AlbumModel) -> Bool {
        return lhs.id == rhs.id // Only check the ID
    }
}

extension AlbumModel {
    init(from dto: AlbumModelDTO) {
        self.albumType = dto.album_type
        self.totalTracks = dto.total_tracks
        self.externalUrl = dto.external_urls.spotify
        self.href = dto.href
        self.id = dto.id
        self.images = dto.images.map { ImageModel(from: $0) }
        self.name = dto.name
        self.releaseDate = dto.release_date
        self.releaseDatePrecision = dto.release_date_precision
        self.restrictionReason = dto.restrictions?.reason
        self.type = dto.type
        self.uri = dto.uri
        self.artists = dto.artists.map { SimplifiedArtistModel(from: $0) }
    }
}
