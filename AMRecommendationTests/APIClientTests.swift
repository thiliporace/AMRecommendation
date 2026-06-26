//
//  APIClientTests.swift
//  AMRecommendationTests
//
//  Created by Thiago Liporace on 26/06/26.
//

import Foundation
import Testing
import XCTest
@testable import AMRecommendation

// Swift Testing - API Client
@Suite("APIClient Tests") struct APIClientTests {
    private struct DummyDTO: Decodable, Equatable { let id: String }
    
    private func makeClient(_ session: NetworkSessionMock) -> APIClient {
        APIClient(session: session, accessToken: "test-token")
    }
    
    @Test("Tests fake DTO decoding") func successDecodesData() async throws {
        let session = NetworkSessionMock(statusCode: 200, data: #"{"id":"track123"}"#.data(using: .utf8)!)
        
        let result: DummyDTO = try await makeClient(session).request(
            path: "/me/top/tracks", queryItems: [], repositoryType: "Tracks"
        )
        #expect(result == DummyDTO(id: "track123"))
    }
    
    @Test("Tests bearer token attaching") func attachesBearerToken() async throws {
        let session = NetworkSessionMock(statusCode: 200, data: #"{"id":"x"}"#.data(using: .utf8)!)
        let dummy: DummyDTO = try await makeClient(session).request(
            path: "/me/top/tracks", queryItems: [], repositoryType: "Tracks")
        #expect(session.lastRequest?.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
    }
    
    @Test("Tests real track DTO decoding") func successDecodesRealData() async throws {
        let json = """
        {
          "album": {
            "album_type": "album", "total_tracks": 14,
            "external_urls": { "spotify": "https://open.spotify.com/album/03guxdOi12XJbnvxvxbpwG" },
            "href": "https://api.spotify.com/v1/albums/03guxdOi12XJbnvxvxbpwG",
            "id": "03guxdOi12XJbnvxvxbpwG",
            "images": [
              { "url": "https://i.scdn.co/image/ab67616d0000b2738aa339341a0b0c813909c831", "height": 640, "width": 640 },
              { "url": "https://i.scdn.co/image/ab67616d00001e028aa339341a0b0c813909c831", "height": 300, "width": 300 },
              { "url": "https://i.scdn.co/image/ab67616d000048518aa339341a0b0c813909c831", "height": 64, "width": 64 }
            ],
            "name": "Submarine", "release_date": "2024-05-31", "release_date_precision": "day",
            "type": "album", "uri": "spotify:album:03guxdOi12XJbnvxvxbpwG",
            "artists": [
              { "external_urls": { "spotify": "https://open.spotify.com/artist/2sSGPbdZJkaSE2AbcGOACx" },
                "href": "https://api.spotify.com/v1/artists/2sSGPbdZJkaSE2AbcGOACx",
                "id": "2sSGPbdZJkaSE2AbcGOACx", "name": "The Marías", "type": "artist",
                "uri": "spotify:artist:2sSGPbdZJkaSE2AbcGOACx" }
            ],
            "is_playable": true
          },
          "artists": [
            { "external_urls": { "spotify": "https://open.spotify.com/artist/2sSGPbdZJkaSE2AbcGOACx" },
              "href": "https://api.spotify.com/v1/artists/2sSGPbdZJkaSE2AbcGOACx",
              "id": "2sSGPbdZJkaSE2AbcGOACx", "name": "The Marías", "type": "artist",
              "uri": "spotify:artist:2sSGPbdZJkaSE2AbcGOACx" }
          ],
          "disc_number": 1, "duration_ms": 206973, "explicit": false,
          "external_ids": { "isrc": "USAT22400841" },
          "external_urls": { "spotify": "https://open.spotify.com/track/3HVRZxCp3BWYuYe8L8BMNH" },
          "href": "https://api.spotify.com/v1/tracks/3HVRZxCp3BWYuYe8L8BMNH",
          "id": "3HVRZxCp3BWYuYe8L8BMNH", "is_playable": true, "name": "Real Life",
          "track_number": 5, "type": "track",
          "uri": "spotify:track:3HVRZxCp3BWYuYe8L8BMNH", "is_local": false
        }
        """.data(using: .utf8)!
        
        let session = NetworkSessionMock(statusCode: 200, data: json)
        
        let dto: TrackModelDTO = try await makeClient(session).request(
            path: "/tracks/3HVRZxCp3BWYuYe8L8BMNH",
            queryItems: [.init(name: "market", value: "US")],
            repositoryType: "Tracks"
        )
        
        #expect(dto.id == "3HVRZxCp3BWYuYe8L8BMNH")
        #expect(dto.name == "Real Life")
        #expect(dto.duration_ms == 206973)
        #expect(dto.track_number == 5)
        #expect(dto.explicit == false)
        #expect(dto.album.name == "Submarine")
        #expect(dto.album.total_tracks == 14)
        #expect(dto.album.images.count == 3)
        #expect(dto.artists.first?.name == "The Marías")
        #expect(dto.external_ids.isrc == "USAT22400841")
    }
    
    @Test("Tests unauthorized 401 response") func testUnauthorizedThrows() async throws {
        let session = NetworkSessionMock(statusCode: 401)
        let client = makeClient(session)
        await #expect(throws: AppErrorEnum.unauthorized(repositoryType: "Tracks")){
            let dummy : DummyDTO = try await client.request(
                path: "/me/top/tracks", queryItems: [], repositoryType: "Tracks"
            )
        }
    }
}

// XCTest - API Client
class APIClientTestsXC : XCTestCase {
    
    private struct DummyDTO: Decodable, Equatable { let id: String }
    
    private func makeClient(_ session: NetworkSessionMock) -> APIClient {
        APIClient(session: session, accessToken: "test-token")
    }
    
    func testSuccessDecodesData() async throws {
        let session = NetworkSessionMock(statusCode: 200, data: #"{"id":"track123"}"#.data(using: .utf8)!)
        
        let client = makeClient(session)
        let result: DummyDTO = try await client.request(
            path: "/me/top/tracks", queryItems: [], repositoryType: "Tracks"
        )
        XCTAssertEqual(result, DummyDTO(id: "track123"))
    }
    
    func testUnauthorizedThrows() async throws {
        let session = NetworkSessionMock(statusCode: 401)
        let client = makeClient(session)
        do {
            let _: DummyDTO = try await client.request(
                path: "/me/top/tracks", queryItems: [], repositoryType: "Tracks"
            )
            XCTFail("Expected an error, none thrown")
        } catch let error as AppErrorEnum {
            guard case .unauthorized = error else {
                return XCTFail("Wrong case: \(error)")
            }
        }
    }
}
