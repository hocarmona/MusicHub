//
//  ContentView.swift
//  MusicHub
//
//  Created by Hector Carmona on 10/5/24.
//

import SwiftUI

struct ArtistListView: View {
    
    @ObservedObject var viewModel = ArtistViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.artists.isEmpty {
                    EmptyStateView()
                } else {
                    List(viewModel.artists, id: \.id) { artist in
                        HStack {
                            if let url = URL(string: artist.thumb) {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(5)
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                            Text(artist.title)
                        }
                    }
                }
            }
            .navigationTitle("Artists")
            .searchable(text: $viewModel.searchQuery, prompt: "Search for an artist")
        }
    }
}

#Preview {
    ArtistListView()
}
