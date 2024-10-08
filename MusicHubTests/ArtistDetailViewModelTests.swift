//
//  ArtistDetailViewModelTests.swift
//  MusicHubTests
//
//  Created by Hector Carmona on 10/7/24.
//

import XCTest
@testable import MusicHub

class ArtistDetailViewModelTests: XCTestCase {
    var viewModel: ArtistDetailViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = ArtistDetailViewModel(artistId: 1, artistImage: "http://example.com/image.jpg")
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testArtistDetailsAreLoaded() {
        let artistDetails = ArtistMoreDetails(
            name: "Test Artist",
            id: 1,
            resourceURL: "http://example.com/resource",
            uri: "http://example.com/uri",
            releasesURL: "http://example.com/releases",
            images: nil,
            profile: "Artist profile",
            urls: nil,
            namevariations: nil,
            aliases: nil,
            members: nil,
            dataQuality: "high"
        )
        
        viewModel.artist = artistDetails
        
        XCTAssertNotNil(viewModel.artist)
        XCTAssertEqual(viewModel.artist?.name, "Test Artist")
        XCTAssertEqual(viewModel.artistImage, "http://example.com/image.jpg")
    }
    
    func testFetchArtistDetailsHandlesError() {
        viewModel.fetchArtistDetails(artistId: 1)
        viewModel.errorMessage = "Error: Failed to load artist details."
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, "Error: Failed to load artist details.")
    }
}
