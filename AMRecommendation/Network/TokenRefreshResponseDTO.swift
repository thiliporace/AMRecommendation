//
//  TokenRefreshResponseDTO.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 26/06/26.
//

import Foundation

struct TokenRefreshResponseDTO {
    let access_token: String
    let token_type: String
    let expires_in: Int
    let refresh_token: String?   // optional — Spotify may omit it
    let scope: String?
}

// Adding nonisolated init explicitly opts the conformance (Decodable) out of the MainActor, so it can be called on Actors without issues
extension TokenRefreshResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case access_token, token_type, expires_in, refresh_token, scope
    }

    nonisolated init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        access_token = try container.decode(String.self, forKey: .access_token)
        token_type = try container.decode(String.self, forKey: .token_type)
        expires_in = try container.decode(Int.self, forKey: .expires_in)
        refresh_token = try container.decodeIfPresent(String.self, forKey: .refresh_token)
        scope = try container.decodeIfPresent(String.self, forKey: .scope)
    }
}
