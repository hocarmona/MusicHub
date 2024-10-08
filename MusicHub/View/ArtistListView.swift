//
//  ContentView.swift
//  MusicHub
//
//  Created by Hector Carmona on 10/5/24.
//

import SwiftUI
import Kingfisher

struct ArtistListView: View {
    
    @StateObject var viewModel = ArtistViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.artists.isEmpty {
                    ScrollView {
                        EmptyStateView()
                    }
                } else {
                    List(viewModel.artists, id: \.id) { artist in
                        Button(action: {
                            viewModel.selectedArtist = artist
                        }) {
                            HStack {
                                if let url = URL(string: artist.thumb) {
                                    KFImage(url)
                                        .placeholder {
                                            ProgressView()
                                        }
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(5)
                                }
                                Text(artist.title)
                            }
                        }
                        .onAppear {
                            viewModel.loadMoreIfNeeded(currentItem: artist)
                        }
                    }
                    .background(
                        NavigationLink(
                            destination: viewModel.selectedArtist.map { artist in
                                ArtistDetailView(artistId: artist.id, artistImage: artist.coverImage)
                            },
                            isActive: Binding<Bool>(
                                get: { viewModel.selectedArtist != nil },
                                set: { if !$0 { viewModel.selectedArtist = nil } }
                            ),
                            label: { EmptyView() }
                        )
                    )
                    
                    if viewModel.isLoadingPage {
                        ProgressView("Loading more artists...")
                    }
                }
            }
            .navigationTitle("Artists")
            .navigationBarTitle("Artist Details", displayMode: .inline)
            .searchable(text: $viewModel.searchQuery, prompt: "Search for an artist")
        }
    }
}


#Preview {
    ArtistListView()
}
