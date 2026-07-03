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
// This Suite of tests is aimed at testing JSON data conversion into our DTO models.
// They also test fake AppErrorEnum throws
@Suite("APIClient Mock Tests") struct APIClientMockTests {
    private struct DummyDTO: Decodable, Equatable { let id: String }
    
    private func makeClient(_ session: NetworkSessionMock) -> APIClient {
        APIClient(session: session, auth: AuthProviderMock())
    }
    
    private func makeClientWithJSON(loading fixture: String) throws -> APIClient {
        let session = NetworkSessionMock(statusCode: 200, data: try FixtureEnum.data(fixture))
        return makeClient(session)
    }
    
    @Test("Tests fake DTO decoding") func successDecodesData() async throws {
        let session = NetworkSessionMock(statusCode: 200, data: #"{"id":"track123"}"#.data(using: .utf8)!)
        
        let result: DummyDTO = try await makeClient(session).request(path: "/me/top/tracks")
        
        #expect(result == DummyDTO(id: "track123"))
    }
    
    @Test("Tests unauthorized 401 response") func testUnauthorizedThrows() async throws {
        let session = NetworkSessionMock(statusCode: 401)
        let client = makeClient(session)
        await #expect(throws: AppErrorEnum.unauthorized){
            let _ : DummyDTO = try await client.request(path: "/me/top/tracks")
        }
    }
    
    @Test("GET /me/top/tracks decodes into paged TrackModelDTO")
    func decodesTopTracks() async throws {
        let page: PagingResponseDTO<TrackModelDTO> = try await makeClientWithJSON(loading: "top_tracks")
            .request(path: "/me/top/tracks")
        
        // PagingResponseDTO
        #expect(page.href == "https://api.spotify.com/v1/me/top/tracks")
        #expect(page.limit == 20)
        #expect(page.next == nil)
        #expect(page.offset == 0)
        #expect(page.previous == nil)
        #expect(page.total == 1)
        #expect(page.items.count == 1)
        
        let track = try #require(page.items.first)
        // TrackModelDTO
        #expect(track.disc_number == 1)
        #expect(track.duration_ms == 206973)
        #expect(track.explicit == false)
        #expect(track.href == "https://api.spotify.com/v1/tracks/3HVRZxCp3BWYuYe8L8BMNH")
        #expect(track.id == "3HVRZxCp3BWYuYe8L8BMNH")
        #expect(track.is_playable == true)
        #expect(track.name == "Real Life")
        #expect(track.track_number == 5)
        #expect(track.type == "track")
        #expect(track.uri == "spotify:track:3HVRZxCp3BWYuYe8L8BMNH")
        #expect(track.is_local == false)
        // ExternalIdsModelDTO
        #expect(track.external_ids.isrc == "USAT22400841")
        // ExternalUrlsModelDTO
        #expect(track.external_urls.spotify == "https://open.spotify.com/track/3HVRZxCp3BWYuYe8L8BMNH")
        
        // Nested AlbumModelDTO
        let album = track.album
        #expect(album.album_type == "album")
        #expect(album.total_tracks == 14)
        #expect(album.href == "https://api.spotify.com/v1/albums/03guxdOi12XJbnvxvxbpwG")
        #expect(album.id == "03guxdOi12XJbnvxvxbpwG")
        #expect(album.name == "Submarine")
        #expect(album.release_date == "2024-05-31")
        #expect(album.release_date_precision == "day")
        #expect(album.type == "album")
        #expect(album.uri == "spotify:album:03guxdOi12XJbnvxvxbpwG")
        #expect(album.external_urls.spotify == "https://open.spotify.com/album/03guxdOi12XJbnvxvxbpwG")
        // ImageModelDTO (first image)
        #expect(album.images.count == 2)
        #expect(album.images.first?.url == "https://i.scdn.co/image/abc640")
        #expect(album.images.first?.height == 640)
        #expect(album.images.first?.width == 640)
        // SimplifiedArtistModelDTO inside the album
        let albumArtist = try #require(album.artists.first)
        #expect(albumArtist.id == "2sSGPbdZJkaSE2AbcGOACx")
        #expect(albumArtist.name == "The Marías")
        #expect(albumArtist.type == "artist")
        #expect(albumArtist.uri == "spotify:artist:2sSGPbdZJkaSE2AbcGOACx")
        #expect(albumArtist.href == "https://api.spotify.com/v1/artists/2sSGPbdZJkaSE2AbcGOACx")
        #expect(albumArtist.external_urls.spotify == "https://open.spotify.com/artist/2sSGPbdZJkaSE2AbcGOACx")
        
        // Track-level artists
        let trackArtist = try #require(track.artists.first)
        #expect(trackArtist.id == "2sSGPbdZJkaSE2AbcGOACx")
        #expect(trackArtist.name == "The Marías")
    }
    
    @Test("Decodes paged ArtistModelDTO with every field")
    func decodesTopArtists() async throws {
        let page: PagingResponseDTO<ArtistModelDTO> = try await makeClientWithJSON(loading: "top_artists")
            .request(path: "/me/top/artists")
        
        #expect(page.limit == 10)
        #expect(page.next != nil)
        #expect(page.offset == 5)
        #expect(page.previous != nil)
        #expect(page.total == 20)
        
        let artist = try #require(page.items.first)
        #expect(artist.id == "1q4618qKswelCGLoanFKQh")
        #expect(artist.name == "Joey Valence & Brae")
        #expect(artist.type == "artist")
        #expect(artist.href == "https://api.spotify.com/v1/artists/1q4618qKswelCGLoanFKQh")
        #expect(artist.uri == "spotify:artist:1q4618qKswelCGLoanFKQh")
        #expect(artist.external_urls.spotify == "https://open.spotify.com/artist/1q4618qKswelCGLoanFKQh")
        
        // ImageModelDTO — now present, widest first (640)
        #expect(artist.images.count == 3)
        let firstImage = try #require(artist.images.first)
        #expect(firstImage.url == "https://i.scdn.co/image/ab6761610000e5ebb36775ce5aa573ca9b33859f")
        #expect(firstImage.height == 640)
        #expect(firstImage.width == 640)
        
        // Spot-check a later artist to confirm the whole array decoded
        #expect(page.items[5].name == "The Marías")
        #expect(page.items[5].id == "2sSGPbdZJkaSE2AbcGOACx")
        // Massive Attack (index 6) has 4 images with non-square dimensions
        #expect(page.items[6].images.count == 4)
        #expect(page.items[6].images.first?.height == 1335)
        #expect(page.items[6].images.first?.width == 1000)
    }
    
    @Test("Decodes single ArtistModelDTO with every field")
    func decodesArtist() async throws {
        let dto: ArtistModelDTO = try await makeClientWithJSON(loading: "artist")
            .request(path: "/artists/2sSGPbdZJkaSE2AbcGOACx")
        
        #expect(dto.id == "2sSGPbdZJkaSE2AbcGOACx")
        #expect(dto.name == "The Marías")
        #expect(dto.type == "artist")
        #expect(dto.uri == "spotify:artist:2sSGPbdZJkaSE2AbcGOACx")
        #expect(dto.external_urls.spotify == "https://open.spotify.com/artist/2sSGPbdZJkaSE2AbcGOACx")
    }
    
    @Test("Decodes paged SimplifiedAlbumModelDTO with every field")
    func decodesArtistAlbums() async throws {
        let page: PagingResponseDTO<SimplifiedAlbumModelDTO> = try await makeClientWithJSON(loading: "artist_albums")
            .request(path: "/artists/2sSGPbdZJkaSE2AbcGOACx/albums")
        
        #expect(page.total == 30)
        let album = try #require(page.items.first)
        #expect(album.album_type == "album")
        #expect(album.total_tracks == 14)
        #expect(album.id == "03guxdOi12XJbnvxvxbpwG")
        #expect(album.name == "Submarine")
        #expect(album.release_date == "2024-05-31")
        #expect(album.release_date_precision == "day")
        #expect(album.type == "album")
        #expect(album.uri == "spotify:album:03guxdOi12XJbnvxvxbpwG")
        #expect(album.external_urls.spotify == "https://open.spotify.com/album/03guxdOi12XJbnvxvxbpwG")
        #expect(album.images.first?.height == 640)
        #expect(album.artists.first?.name == "The Marías")
    }
    
    @Test("Decodes cursor-paged PlayHistoryModelDTO with every field")
    func decodesRecentlyPlayed() async throws {
        let page: CursorPagingResponseDTO<PlayHistoryModelDTO> = try await makeClientWithJSON(loading: "recently_played")
            .request(path: "/me/player/recently-played")
        
        // CursorPagingResponseDTO
        #expect(page.href == "https://api.spotify.com/v1/me/player/recently-played")
        #expect(page.limit == 20)
        #expect(page.next == nil)
        #expect(page.total == nil)               // not present in cursor responses
        // CursorsModelDTO
        #expect(page.cursors.after == "1718000000000")
        #expect(page.cursors.before == "1717900000000")
        
        // PlayHistoryModelDTO
        let history = try #require(page.items.first)
        #expect(history.played_at == "2024-06-10T12:00:00.000Z")
        #expect(history.track.name == "Real Life")
        #expect(history.track.id == "3HVRZxCp3BWYuYe8L8BMNH")
        // ContextModelDTO
        #expect(history.context.type == "playlist")
        #expect(history.context.uri == "spotify:playlist:37i9dQ")
        #expect(history.context.external_urls.spotify == "https://open.spotify.com/playlist/37i9dQ")
    }
    
    
    // XCTest - API Client
    class APIClientTestsXC: XCTestCase {
        
        private struct DummyDTO: Decodable, Equatable { let id: String }
        
        private func makeClient(_ session: NetworkSessionMock) -> APIClient {
            APIClient(session: session, auth: AuthProviderMock())
        }
        
        func testSuccessDecodesData() async throws {
            let session = NetworkSessionMock(statusCode: 200, data: #"{"id":"track123"}"#.data(using: .utf8)!)
            
            let client = makeClient(session)
            let result: DummyDTO = try await client.request(path: "/me/top/tracks")
            XCTAssertEqual(result, DummyDTO(id: "track123"))
        }
        
        func testUnauthorizedThrows() async throws {
            let session = NetworkSessionMock(statusCode: 401)
            let client = makeClient(session)
            do {
                let _: DummyDTO = try await client.request(path: "/me/top/tracks")
                XCTFail("Expected an error, none thrown")
            } catch let error as AppErrorEnum {
                guard case .unauthorized = error else {
                    return XCTFail("Wrong case: \(error)")
                }
            }
        }
    }
}
