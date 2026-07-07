//
//  RepositoryTests.swift
//  AMRecommendationTests
//
//  Created by Thiago Liporace on 30/06/26.
//

import Foundation
import Testing
@testable import AMRecommendation

// This Suite of tests is aimed at testing JSON data conversion into our Domain Models
// They also test error throws from the API Client
@Suite("AlbumRepository Tests with JSON Fixtures")
struct AlbumRepositoryMockTests {
    
    private func makeClientWithJSON() throws -> APIClientMock {
        let result: Result<Data, Error> = try .success(FixtureEnum.data("artist_albums"))
        return APIClientMock(result: result)
    }
    
    @Test("getArtistAlbums maps every SimplifiedAlbumModel field and builds the request")
    func mapsAndBuildsRequest() async throws {
        let mock = try makeClientWithJSON()
        
        let repo = AlbumRepositoryImpl(apiClient: mock)
        
        let albums = try await repo.getArtistAlbums(
            id: "2sSGPbdZJkaSE2AbcGOACx",
            include_groups: [.album,.appearsOn,.compilation,.single],
            market: .us,
            limit: 10,
            offset: 0
        )
        
        #expect(albums.count == 10)
        let album = try #require(albums.first)

        // Every SimplifiedAlbumModel field
        #expect(album.albumType == "album")
        #expect(album.totalTracks == 14)
        #expect(album.externalUrl == "https://open.spotify.com/album/03guxdOi12XJbnvxvxbpwG") // flattened from external_urls.spotify
        #expect(album.href == "https://api.spotify.com/v1/albums/03guxdOi12XJbnvxvxbpwG")
        #expect(album.id == "03guxdOi12XJbnvxvxbpwG")
        #expect(album.name == "Submarine")
        #expect(album.releaseDate == "2024-05-31")
        #expect(album.releaseDatePrecision == "day")
        #expect(album.restrictionReason == nil)        // unwrapped from restrictions?.reason
        #expect(album.type == "album")
        #expect(album.uri == "spotify:album:03guxdOi12XJbnvxvxbpwG")

        // Nested images mapping
        #expect(album.images.count == 3)
        let image = try #require(album.images.first)
        #expect(image.url == "https://i.scdn.co/image/ab67616d0000b2738aa339341a0b0c813909c831")
        #expect(image.height == 640)
        #expect(image.width == 640)

        // Nested artists mapping
        #expect(album.artists.count == 1)
        let artist = try #require(album.artists.first)
        #expect(artist.id == "2sSGPbdZJkaSE2AbcGOACx")
        #expect(artist.name == "The Marías")
        #expect(artist.externalUrl == "https://open.spotify.com/artist/2sSGPbdZJkaSE2AbcGOACx") // adjust if your field differs

        // AND — the repository built the request correctly
        #expect(mock.lastPath == "/artists/2sSGPbdZJkaSE2AbcGOACx/albums")
        #expect(mock.lastQueryItems.contains { $0.name == "market" && $0.value == "US" })
        #expect(mock.lastQueryItems.contains { $0.name == "limit" && $0.value == "10" })
        #expect(mock.lastQueryItems.contains { $0.name == "offset" && $0.value == "0" })
    }
    
    @Test("getArtistAlbums propagates errors from the client")
    func propagatesError() async throws {
        let mock = APIClientMock(result: .failure(AppErrorEnum.unauthorized))
        let repo = AlbumRepositoryImpl(apiClient: mock)

        await #expect(throws: AppErrorEnum.self) {
            _ = try await repo.getArtistAlbums(
                id: "abc", include_groups: [.album,.appearsOn,.compilation,.single], market: .us, limit: 10, offset: 0
            )
        }
    }
}

@Suite("ArtistRepository Tests with JSON Fixtures")
struct ArtistRepositoryMockTests {

    private func makeClientWithTopArtistsJSON() throws -> APIClientMock {
        let result: Result<Data, Error> = try .success(FixtureEnum.data("top_artists"))
        return APIClientMock(result: result)
    }

    private func makeClientWithArtistJSON() throws -> APIClientMock {
        let result: Result<Data, Error> = try .success(FixtureEnum.data("artist"))
        return APIClientMock(result: result)
    }

    @Test("getUserTopArtists maps every ArtistModel field and builds the request")
    func getUserTopArtistsMapsAndBuildsRequest() async throws {
        let mock = try makeClientWithTopArtistsJSON()
        let repo = ArtistRepositoryImpl(apiClient: mock)

        let artists = try await repo.getUserTopArtists(time_range: .mediumTerm, limit: 10, offset: 5)

        #expect(artists.count == 10)
        let artist = try #require(artists.first)

        #expect(artist.id == "1q4618qKswelCGLoanFKQh")
        #expect(artist.name == "Joey Valence & Brae")
        #expect(artist.externalUrl == "https://open.spotify.com/artist/1q4618qKswelCGLoanFKQh")
        #expect(artist.href == "https://api.spotify.com/v1/artists/1q4618qKswelCGLoanFKQh")
        #expect(artist.type == "artist")
        #expect(artist.uri == "spotify:artist:1q4618qKswelCGLoanFKQh")

        #expect(artist.images.count == 3)
        let image = try #require(artist.images.first)
        #expect(image.url == "https://i.scdn.co/image/ab6761610000e5ebb36775ce5aa573ca9b33859f")
        #expect(image.height == 640)
        #expect(image.width == 640)

        #expect(mock.lastPath == "/me/top/artists")
        #expect(mock.lastQueryItems.contains { $0.name == "time_range" && $0.value == "medium_term" })
        #expect(mock.lastQueryItems.contains { $0.name == "limit" && $0.value == "10" })
        #expect(mock.lastQueryItems.contains { $0.name == "offset" && $0.value == "5" })
    }

    @Test("getUserTopArtists propagates errors from the client")
    func getUserTopArtistsPropagatesError() async throws {
        let mock = APIClientMock(result: .failure(AppErrorEnum.unauthorized))
        let repo = ArtistRepositoryImpl(apiClient: mock)

        await #expect(throws: AppErrorEnum.self) {
            _ = try await repo.getUserTopArtists(time_range: .mediumTerm, limit: 10, offset: 0)
        }
    }

    @Test("getArtist maps every ArtistModel field and builds the request")
    func getArtistMapsAndBuildsRequest() async throws {
        let mock = try makeClientWithArtistJSON()
        let repo = ArtistRepositoryImpl(apiClient: mock)

        let artist = try await repo.getArtist(id: "2sSGPbdZJkaSE2AbcGOACx")

        #expect(artist.id == "2sSGPbdZJkaSE2AbcGOACx")
        #expect(artist.name == "The Marías")
        #expect(artist.externalUrl == "https://open.spotify.com/artist/2sSGPbdZJkaSE2AbcGOACx")
        #expect(artist.type == "artist")
        #expect(artist.uri == "spotify:artist:2sSGPbdZJkaSE2AbcGOACx")

        #expect(artist.images.count == 3)
        let image = try #require(artist.images.first)
        #expect(image.url == "https://i.scdn.co/image/ab6761610000e5ebaf586afa2b397f1288683a76")
        #expect(image.height == 640)
        #expect(image.width == 640)

        #expect(mock.lastPath == "/artists/2sSGPbdZJkaSE2AbcGOACx")
    }

    @Test("getArtist propagates errors from the client")
    func getArtistPropagatesError() async throws {
        let mock = APIClientMock(result: .failure(AppErrorEnum.unauthorized))
        let repo = ArtistRepositoryImpl(apiClient: mock)

        await #expect(throws: AppErrorEnum.self) {
            _ = try await repo.getArtist(id: "abc")
        }
    }
}

@Suite("TrackRepository Tests with JSON Fixtures")
struct TrackRepositoryMockTests {

    private func makeClientWithTopTracksJSON() throws -> APIClientMock {
        let result: Result<Data, Error> = try .success(FixtureEnum.data("top_tracks"))
        return APIClientMock(result: result)
    }

    @Test("getUserTopTracks maps every TrackModel field and builds the request")
    func getUserTopTracksMapsAndBuildsRequest() async throws {
        let mock = try makeClientWithTopTracksJSON()
        let repo = TrackRepositoryImpl(apiClient: mock)

        let tracks = try await repo.getUserTopTracks(time_range: .mediumTerm, limit: 20, offset: 0)

        #expect(tracks.count == 1)
        let track = try #require(tracks.first)

        #expect(track.id == "3HVRZxCp3BWYuYe8L8BMNH")
        #expect(track.name == "Real Life")
        #expect(track.discNumber == 1)
        #expect(track.duration == 206973)
        #expect(track.explicit == false)
        #expect(track.isPlayable == true)
        #expect(track.isLocal == false)
        #expect(track.trackNumber == 5)
        #expect(track.type == "track")
        #expect(track.uri == "spotify:track:3HVRZxCp3BWYuYe8L8BMNH")
        #expect(track.href == "https://api.spotify.com/v1/tracks/3HVRZxCp3BWYuYe8L8BMNH")
        #expect(track.externalUrl == "https://open.spotify.com/track/3HVRZxCp3BWYuYe8L8BMNH")
        #expect(track.restrictionReason == nil)

        // External IDs mapping
        #expect(track.externalIds.isrc == "USAT22400841")
        #expect(track.externalIds.ean == nil)
        #expect(track.externalIds.upc == nil)

        // Nested album mapping
        #expect(track.album.id == "03guxdOi12XJbnvxvxbpwG")
        #expect(track.album.name == "Submarine")
        #expect(track.album.images.count == 2)

        // Nested track artists mapping
        #expect(track.artists.count == 1)
        let artist = try #require(track.artists.first)
        #expect(artist.id == "2sSGPbdZJkaSE2AbcGOACx")
        #expect(artist.name == "The Marías")

        #expect(mock.lastPath == "/me/top/tracks")
        #expect(mock.lastQueryItems.contains { $0.name == "time_range" && $0.value == "medium_term" })
        #expect(mock.lastQueryItems.contains { $0.name == "limit" && $0.value == "20" })
        #expect(mock.lastQueryItems.contains { $0.name == "offset" && $0.value == "0" })
    }

    @Test("getUserTopTracks propagates errors from the client")
    func getUserTopTracksPropagatesError() async throws {
        let mock = APIClientMock(result: .failure(AppErrorEnum.unauthorized))
        let repo = TrackRepositoryImpl(apiClient: mock)

        await #expect(throws: AppErrorEnum.self) {
            _ = try await repo.getUserTopTracks(time_range: .mediumTerm, limit: 20, offset: 0)
        }
    }

    @Test("getUserRecentlyPlayedTracks propagates errors from the client")
    func getUserRecentlyPlayedTracksPropagatesError() async throws {
        let mock = APIClientMock(result: .failure(AppErrorEnum.unauthorized))
        let repo = TrackRepositoryImpl(apiClient: mock)

        await #expect(throws: AppErrorEnum.self) {
            _ = try await repo.getUserRecentlyPlayedTracks(limit: 20, after: nil, before: nil)
        }
    }
}
