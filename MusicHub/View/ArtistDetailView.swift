//
//  ArtistDetailView.swift
//  MusicHub
//
//  Created by Hector Carmona on 10/6/24.
//

import SwiftUI
import Kingfisher

// MARK: - ArtistDetailView
struct ArtistDetailView: View {
    @ObservedObject var viewModel: ArtistDetailViewModel

    init(artistId: Int, artistImage: String?) {
        self.viewModel = ArtistDetailViewModel(artistId: artistId, artistImage: artistImage)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let artistImage = viewModel.artistImage, let url = URL(string: artistImage) {
                    ZStack(alignment: .bottomLeading) {
                        KFImage(url)
                            .placeholder {
                                ProgressView()
                            }
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity, maxHeight: 250)
                            .clipped()
                            .ignoresSafeArea(edges: .top)
                        if !viewModel.isLoading, let artistName = viewModel.artist?.name {
                            Text(artistName)
                                .font(.system(size: 36, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.black.opacity(0.5))
                                .cornerRadius(10)
                                .padding([.leading, .bottom], 16)
                        }
                    }
                }
                
                if let members = viewModel.artist?.members, !members.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Band Members")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(members, id: \.self.name) { member in
                                    Text(member.name)
                                        .font(.callout)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(Color.blue.opacity(0.7))
                                        .foregroundColor(.white)
                                        .cornerRadius(12)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                if let summary = viewModel.artist?.profile {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("About the Artist")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                        
                        ScrollView {
                            Text(summary)
                                .font(.body)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                        }
                        .frame(height: 200)
                        .padding(.horizontal)
                    }
                }
                NavigationLink(destination: ArtistAlbumsView(artistId: viewModel.artistId)) {
                    Text("View Albums")
                        .font(.title2)
                        .bold()
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.top, 10)
                }
            }
            .padding(.top, 8)
        }
        .navigationBarTitle("Artist Details", displayMode: .inline)
    }
}



#Preview {
    let  sampleArtistDetail = ArtistMoreDetails(name: "", id: 1, resourceURL: "", uri: "", releasesURL: "", images: [], profile: "", urls: [""], namevariations: [], aliases: [], members: [], dataQuality: "")
    
    let viewModel = ArtistDetailViewModel(artistId: 1, artistImage: "")
    viewModel.artist = sampleArtistDetail

    return ArtistDetailView(
        artistId: 1,
        artistImage: "https://via.placeholder.com/300"
    )
}

