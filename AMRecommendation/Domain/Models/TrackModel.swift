//
//  TrackModel.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 24/06/26.
//

import Foundation

struct TrackModel: Equatable {
    // The album on which the track appears. The album object includes a link in href to full information about the album.
    let album: AlbumModel
    // The artists who performed the track. Each artist object includes a link in href to more detailed information about the artist.
    let artists: [SimplifiedArtistModel]
    // The disc number (usually 1 unless the album consists of more than one disc).
    let discNumber: Int
    // The track length in milliseconds.
    let duration: Int
    // Whether or not the track has explicit lyrics ( true = yes it does; false = no it does not OR unknown).
    let explicit: Bool
    // Known external IDs for the track.
    let externalIds: ExternalIdsModel
    // Known external URLs for this track.
    let externalUrl: String
    // A link to the Web API endpoint providing full details of the track.
    let href: String
    // The Spotify ID for the track.
    let id: String
    // Part of the response when Track Relinking is applied. If true, the track is playable in the given market. Otherwise false.
    let isPlayable: Bool
    // The reason for the restriction. Supported values: market - The content item is not available in the given market.
    // product - The content item is not available for the user's subscription type.
    // explicit - The content item is explicit and the user's account is set to not play explicit content.
    let restrictionReason: String?
    // The name of the track.
    let name: String
    // The number of the track. If an album has several discs, the track number is the number on the specified disc.
    let trackNumber: Int
    // The object type: "track".
    let type: String
    // The Spotify URI for the track.
    let uri: String
    // Whether or not the track is from a local file.
    let isLocal: Bool

    static func == (lhs: TrackModel, rhs: TrackModel) -> Bool {
        return lhs.id == rhs.id // Only check the ID
    }
}

extension TrackModel {
    init(from dto: TrackModelDTO) {
        self.album = AlbumModel(from: dto.album)
        self.artists = dto.artists.map { SimplifiedArtistModel(from: $0) }
        self.discNumber = dto.disc_number
        self.duration = dto.duration_ms
        self.explicit = dto.explicit
        self.externalIds = ExternalIdsModel(from: dto.external_ids)
        self.externalUrl = dto.external_urls.spotify
        self.href = dto.href
        self.id = dto.id
        self.isPlayable = dto.is_playable ?? true
        self.restrictionReason = dto.restrictions?.reason
        self.name = dto.name
        self.trackNumber = dto.track_number
        self.type = dto.type
        self.uri = dto.uri
        self.isLocal = dto.is_local
    }
}
