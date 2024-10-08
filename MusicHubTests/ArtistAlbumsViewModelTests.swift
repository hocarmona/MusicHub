//
//  ArtistAlbumsViewModelTests.swift
//  MusicHubTests
//
//  Created by Hector Carmona on 10/7/24.
//

import XCTest
@testable import MusicHub

class ArtistAlbumsViewModelTests: XCTestCase {
    var viewModel: ArtistAlbumsViewModel!

    override func setUp() {
        super.setUp()
        viewModel = ArtistAlbumsViewModel(artistId: 1)
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testInitialLoadingState() {
        XCTAssertTrue(viewModel.isLoading)
    }

    func testFetchArtistReleasesSuccess() {
        let pagination = Pagination(page: 1, pages: 1, perPage: 10, items: 2, urls: Urls(last: "url_last", next: "url_next"))
        let albums = ArtistAlbums(pagination: pagination, releases: [
            Release(id: 1, status: nil, type: .artist, format: "Vinyl", label: "Label 1", title: "Album 1", resourceURL: nil, role: nil, artist: "Artist 1", year: 2023, thumb: nil, stats: nil, mainRelease: nil),
            Release(id: 2, status: nil, type: .release, format: "CD", label: "Label 2", title: "Album 2", resourceURL: nil, role: nil, artist: "Artist 2", year: 2022, thumb: nil, stats: nil, mainRelease: nil)
        ])
        viewModel.albums = albums
        XCTAssertEqual(viewModel.albums?.releases.count, 2)
        XCTAssertEqual(viewModel.albums?.releases.first?.title, "Album 1")
        XCTAssertTrue(viewModel.isLoading)
    }

    func testFetchArtistReleasesHandlesError() {
        viewModel.fetchArtistReleases(artistId: 1, page: 1)
        viewModel.errorMessage = "Error: Failed to load albums."
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, "Error: Failed to load albums.")
    }

    func testLoadMoreAlbumsIfNeeded() {
        let release1 = Release(id: 1, status: nil, type: .artist, format: "Vinyl", label: "Label 1", title: "Album 1", resourceURL: nil, role: nil, artist: "Artist 1", year: 2023, thumb: nil, stats: nil, mainRelease: nil)
        let release2 = Release(id: 2, status: nil, type: .artist, format: "CD", label: "Label 2", title: "Album 2", resourceURL: nil, role: nil, artist: "Artist 2", year: 2022, thumb: nil, stats: nil, mainRelease: nil)

        viewModel.albums = ArtistAlbums(pagination: Pagination(page: 1, pages: 1, perPage: 10, items: 2, urls: Urls(last: "url_last", next: "url_next")), releases: [release1, release2])
        viewModel.currentPage = 1
        viewModel.loadMoreAlbumsIfNeeded(currentAlbum: release2)

        XCTAssertEqual(viewModel.currentPage, 2)
    }

    func testUniqueYearsAndLabels() {
        viewModel.albums = ArtistAlbums(pagination: Pagination(page: 1, pages: 1, perPage: 10, items: 3, urls: Urls(last: "url_last", next: "url_next")), releases: [
            Release(id: 1, status: nil, type: .artist, format: "Vinyl", label: "Label 1", title: "Album 1", resourceURL: nil, role: nil, artist: "Artist 1", year: 2023, thumb: nil, stats: nil, mainRelease: nil),
            Release(id: 2, status: nil, type: .master, format: "CD", label: "Label 1", title: "Album 2", resourceURL: nil, role: nil, artist: "Artist 2", year: 2022, thumb: nil, stats: nil, mainRelease: nil),
            Release(id: 3, status: nil, type: .release, format: "Digital", label: "Label 2", title: "Album 3", resourceURL: nil, role: nil, artist: "Artist 3", year: 2023, thumb: nil, stats: nil, mainRelease: nil)
        ])

        XCTAssertEqual(viewModel.uniqueYears, [2023, 2022])
        XCTAssertEqual(viewModel.uniqueLabels, ["Label 1", "Label 2"])
    }

    func testFilteredAlbums() {
        viewModel.albums = ArtistAlbums(pagination: Pagination(page: 1, pages: 1, perPage: 10, items: 3, urls: Urls(last: "url_last", next: "url_next")), releases: [
            Release(id: 1, status: nil, type: .release, format: "Vinyl", label: "Label 1", title: "Album 1", resourceURL: nil, role: nil, artist: "Artist 1", year: 2023, thumb: nil, stats: nil, mainRelease: nil),
            Release(id: 2, status: nil, type: .artist, format: "CD", label: "Label 2", title: "Album 2", resourceURL: nil, role: nil, artist: "Artist 2", year: 2022, thumb: nil, stats: nil, mainRelease: nil),
            Release(id: 3, status: nil, type: .master, format: "Digital", label: "Label 2", title: "Album 3", resourceURL: nil, role: nil, artist: "Artist 3", year: 2023, thumb: nil, stats: nil, mainRelease: nil)
        ])

        viewModel.selectedYear = 2023
        XCTAssertEqual(viewModel.filteredAlbums.count, 2)
        XCTAssertEqual(viewModel.filteredAlbums.first?.title, "Album 1")
    }
}
