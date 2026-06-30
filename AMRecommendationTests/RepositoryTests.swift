//
//  AlbumRepositoryTests.swift
//  AMRecommendationTests
//
//  Created by Thiago Liporace on 30/06/26.
//

import Foundation
import Testing
@testable import AMRecommendation

@Suite("AlbumRepository Tests with JSON Fixtures")
struct AlbumRepositoryTests {
    
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
        let mock = APIClientMock(result: .failure(AppErrorEnum.unauthorized(repositoryType: "Albums")))
        let repo = AlbumRepositoryImpl(apiClient: mock)
        
        await #expect(throws: AppErrorEnum.self) {
            _ = try await repo.getArtistAlbums(
                id: "abc", include_groups: [.album,.appearsOn,.compilation,.single], market: .us, limit: 10, offset: 0
            )
        }
    }
}
