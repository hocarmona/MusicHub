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

    init(artistId: Int) {
        self.artistId = artistId
        fetchArtistReleases(artistId: artistId)
    }
    
    func fetchArtistReleases(artistId: Int) {
        apiManager.fetchArtistReleases(artistId: artistId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let albums):
                    self?.isLoading = false
                    self?.albums = albums
                case .failure(let error):
                    self?.isLoading = false
                    self?.errorMessage = "Error: \(error.localizedDescription)"
                }
            }
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

        if let year = selectedYear {
            albums = albums.filter { $0.year == year }
        }

        if let label = selectedLabel {
            albums = albums.filter { $0.label == label }
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
