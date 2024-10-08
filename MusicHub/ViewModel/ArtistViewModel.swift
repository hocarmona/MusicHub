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
                resetPagination() // Reiniciamos al realizar una nueva búsqueda
                searchArtist(query: searchQuery)
            } else {
                artists = []
                return
            }
        }
    }
    @Published var isLoadingPage = false // Nuevo indicador de carga

    private let apiManager = DiscogsAPIManager()
    private var currentPage = 1
    private var totalPages = 1
    private let itemsPerPage = 30

    func searchArtist(query: String, page: Int = 1) {
        if query.isEmpty || isLoadingPage {
            return
        }

        isLoadingPage = true

        apiManager.searchArtist(query: query, page: page, itemsPerPage: itemsPerPage) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoadingPage = false

                switch result {
                case .success(let searchResult):
                    self?.currentPage = page
                    self?.totalPages = searchResult.pagination.pages
                    if page == 1 {
                        self?.artists = searchResult.results
                    } else {
                        self?.artists += searchResult.results
                    }
                case .failure(let error):
                    self?.errorMessage = "Error: \(error.localizedDescription)"
                }
            }
        }
    }

    func loadMoreIfNeeded(currentItem: SearchResult?) {
        guard let currentItem = currentItem else { return }
        
        let thresholdIndex = artists.index(artists.endIndex, offsetBy: -5)
        if artists.firstIndex(where: { $0.id == currentItem.id }) == thresholdIndex && currentPage < totalPages {
            loadNextPage()
        }
    }

    func loadNextPage() {
        searchArtist(query: searchQuery, page: currentPage + 1)
    }

    private func resetPagination() {
        currentPage = 1
        totalPages = 1
        artists = []
    }
}

