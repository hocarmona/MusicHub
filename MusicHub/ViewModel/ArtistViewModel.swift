//
//  ArtistViewModel.swift
//  MusicHub
//
//  Created by Hector Carmona on 10/6/24.
//

import SwiftUI

class ArtistViewModel: ObservableObject {
    @Published var selectedArtist: SearchResult?
    @Published var artists: [SearchResult] = []
    @Published var errorMessage: String? = nil
    @Published var searchQuery: String = "" {
        didSet {
            if !searchQuery.isEmpty {
                searchArtist(query: searchQuery)
            } else {
                artists = []
                return
            }
        }
    }

    private let apiManager = DiscogsAPIManager()

    func searchArtist(query: String) {
        if query.isEmpty {
            artists = []
            return
        }
        apiManager.searchArtist(query: query) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let artists):
                    self?.artists = artists
                case .failure(let error):
                    self?.errorMessage = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
}

