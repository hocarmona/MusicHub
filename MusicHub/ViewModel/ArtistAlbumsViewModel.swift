//
//  ArtistAlbumsViewModel.swift
//  MusicHub
//
//  Created by Hector Carmona on 10/7/24.
//

import SwiftUI

class ArtistAlbumsViewModel: ObservableObject {
    
    @Published var isLoading: Bool = true
    let artistId: Int
    @Published var albums: ArtistAlbums?
    private let apiManager = DiscogsAPIManager()
    @Published var errorMessage: String?
    @Published var selectedYear: Int? = nil
    @Published var selectedLabel: String? = nil
    @Published var selectedSortOption: SortOption = .releaseDate
    @Published var currentPage: Int = 1
    private var hasMoreAlbums: Bool = true

    init(artistId: Int) {
        self.artistId = artistId
        fetchArtistReleases(artistId: artistId, page: currentPage)
    }
    
    func fetchArtistReleases(artistId: Int, page: Int) {
        isLoading = true
        apiManager.fetchArtistReleases(artistId: artistId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let albums):
                    if albums.releases.isEmpty {
                        self?.hasMoreAlbums = false
                    } else {
                        self?.hasMoreAlbums = true
                        if self?.albums == nil {
                            self?.albums = albums
                        } else {
                            self?.albums?.releases.append(contentsOf: albums.releases)
                        }
                    }
                case .failure(let error):
                    self?.errorMessage = "Error: \(error.localizedDescription)"
                }
            }
        }
    }

    func loadMoreAlbumsIfNeeded(currentAlbum: Release) {
        let thresholdIndex = albums?.releases.index(albums!.releases.endIndex, offsetBy: -1) ?? 0
        if albums?.releases.firstIndex(where: { $0.id == currentAlbum.id }) == thresholdIndex, hasMoreAlbums {
            currentPage += 1
            fetchArtistReleases(artistId: artistId, page: currentPage)
        }
    }
    
    var uniqueYears: [Int] {
        let years = albums?.releases.compactMap { $0.year }
        return Array(Set(years ?? [])).sorted(by: >)
    }

    var uniqueLabels: [String] {
        let labels = albums?.releases.compactMap { $0.label }
        return Array(Set(labels ?? [])).sorted()
    }
    
    var filteredAlbums: [Release] {
        var albums = albums?.releases ?? []

        if let selectedYear {
            albums = albums.filter { $0.year == selectedYear }
        }

        if let selectedLabel {
            albums = albums.filter { $0.label == selectedLabel }
        }

        switch selectedSortOption {
            case .releaseDate:
                albums = albums.sorted { ($0.year ?? 0) > ($1.year ?? 0) }
            case .title:
                albums = albums.sorted { $0.title < $1.title }
        }

        return albums
    }
}

