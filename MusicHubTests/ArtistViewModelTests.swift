//
//  ArtistViewModelTests.swift
//  MusicHubTests
//
//  Created by Hector Carmona on 10/7/24.
//

import XCTest
@testable import MusicHub

class ArtistViewModelTests: XCTestCase {
    var viewModel: ArtistViewModel!

    override func setUp() {
        super.setUp()
        viewModel = ArtistViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testSearchQueryTriggersSearch() {
        viewModel.searchQuery = "Test Artist"
        XCTAssertEqual(viewModel.artists.count, 0)
        viewModel.searchArtist(query: viewModel.searchQuery)
    }
    
    func testSearchArtistHandlesError() {
        viewModel.searchArtist(query: "")
        XCTAssertEqual(viewModel.errorMessage, nil)
    }
    
    func testLoadMoreIfNeeded() {
        let artist1 = SearchResult(
            id: 1,
            type: .artist,
            userData: UserData(inWantlist: true, inCollection: false),
            masterID: nil,
            masterURL: nil,
            uri: "http://example.com",
            title: "Artist 1",
            thumb: "http://example.com/thumb.jpg",
            coverImage: "http://example.com/cover.jpg",
            resourceURL: "http://example.com/resource"
        )

        let artist2 = SearchResult(
            id: 2,
            type: .artist,
            userData: UserData(inWantlist: true, inCollection: true),
            masterID: nil,
            masterURL: nil,
            uri: "http://example.com",
            title: "Artist 2",
            thumb: "http://example.com/thumb2.jpg",
            coverImage: "http://example.com/cover2.jpg",
            resourceURL: "http://example.com/resource2"
        )

        viewModel.artists = [artist1, artist2]
        viewModel.currentPage = 1
        viewModel.totalPages = 2

        viewModel.loadMoreIfNeeded(currentItem: artist2)
        XCTAssertEqual(viewModel.currentPage, 1)
    }
}

