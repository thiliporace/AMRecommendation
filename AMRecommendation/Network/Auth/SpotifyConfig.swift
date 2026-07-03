//
//  SpotifyConfig.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 03/07/26.
//

import Foundation

// Create SpotifyConfig struct using info.plist variables
struct SpotifyConfig: Sendable {
    let clientId: String
    let redirectUri: String
    let scopes: [String]
    
    static func fromBundle (scopes: [String] = ["user-top-read","user-read-recently-played"]) throws -> SpotifyConfig {
        guard let clientId = Bundle.main.infoDictionary?["SPOTIFY_CLIENT_ID"] as? String, !clientId.isEmpty,
              let redirectUri = Bundle.main.infoDictionary?["SPOTIFY_REDIRECT_URI"] as? String, !redirectUri.isEmpty else {
            throw AppErrorEnum.accessTokenMissing
        }
        return SpotifyConfig(clientId: clientId, redirectUri: redirectUri, scopes: scopes)
    }
}
