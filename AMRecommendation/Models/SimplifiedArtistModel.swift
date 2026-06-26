//
//  SimplifiedArtistModel.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 24/06/26.
//

import Foundation

struct SimplifiedArtistModel: Equatable {
    // Known external URLs for this album. Only Spotify string needs to be filled.
    let externalUrl: String
    // A link to the Web API endpoint providing full details of the artist.
    let href: String
    // The Spotify ID for the artist.
    let id: String
    // The name of the artist.
    let name: String
    // The object type.
    let type: String
    // The Spotify URI for the artist.
    let uri: String

    static func == (lhs: SimplifiedArtistModel, rhs: SimplifiedArtistModel) -> Bool {
        return lhs.id == rhs.id // Only check the ID
    }
}
