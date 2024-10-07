//
//  SortOption.swift
//  MusicHub
//
//  Created by Hector Carmona on 10/7/24.
//

import Foundation

enum SortOption: String, CaseIterable, Identifiable {
    case releaseDate = "Release Date"
    case title = "Title"
    var id: String { self.rawValue }
}
