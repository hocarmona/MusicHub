//
//  ArtistDetailViewModel.swift
//  MusicHub
//
//  Created by Hector Carmona on 10/6/24.
//

import SwiftUI

class ArtistDetailViewModel: ObservableObject {
    
    @Published var isLoading: Bool = true
    let artistId: Int
    let artistImage: String?
    @Published var artist: ArtistMoreDetails?
    private let apiManager: DiscogsAPIManagerProtocol
    @Published var errorMessage: String?

    init(artistId: Int, artistImage: String?, apiManager: DiscogsAPIManagerProtocol = DiscogsAPIManager()) {
        self.artistId = artistId
        self.artistImage = artistImage
        self.apiManager = apiManager
        fetchArtistDetails(artistId: artistId)
    }
    
    func fetchArtistDetails(artistId: Int) {
        apiManager.fetchArtistDetails(artistId: artistId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let artistDetails):
                    self?.isLoading = false
                    self?.artist = artistDetails
                case .failure(let error):
                    self?.isLoading = false
                    self?.errorMessage = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
}
