//
//  ArtistAlbumsView.swift
//  MusicHub
//
//  Created by Hector Carmona on 10/7/24.
//

import SwiftUI

struct ArtistAlbumsView: View {
    @ObservedObject var viewModel: ArtistAlbumsViewModel

    init(artistId: Int) {
        self.viewModel = ArtistAlbumsViewModel(artistId: artistId)
    }

    var body: some View {
        VStack {
            HStack {
                Picker("Year", selection: $viewModel.selectedYear) {
                    Text("All Years").tag(nil as Int?)
                    ForEach(viewModel.uniqueYears, id: \.self) { year in
                        Text("\(year)").tag(year as Int?)
                    }
                }.pickerStyle(MenuPickerStyle())

                Picker("Label", selection: $viewModel.selectedLabel) {
                    Text("All Labels").tag(nil as String?)
                    ForEach(viewModel.uniqueLabels, id: \.self) { label in
                        Text(label).tag(label as String?)
                    }
                }.pickerStyle(MenuPickerStyle())
            }

            Picker("Sort by", selection: $viewModel.selectedSortOption) {
                ForEach(SortOption.allCases) { option in
                    Text(option.rawValue).tag(option)
                }
            }.pickerStyle(SegmentedPickerStyle())
            .padding()

            List(viewModel.filteredAlbums, id: \.id) { album in
                HStack {
                    AsyncImage(url: URL(string: album.thumb ?? ""))
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 5))

                    VStack(alignment: .leading) {
                        Text(album.title).font(.headline)
                        Text(album.artist ?? "Unknown Artist").font(.subheadline)
                        Text("Year: \(album.year ?? 0)").font(.caption)
                        Text("Label: \(album.label ?? "Unknown Label")").font(.caption)
                    }
                }
            }
        }
        .onAppear {}
    }
}

#Preview {
    ArtistAlbumsView(artistId: 1)
}
