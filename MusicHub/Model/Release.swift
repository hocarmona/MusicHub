//
//  Release.swift
//  MusicHub
//
//  Created by Hector Carmona on 10/6/24.
//

import Foundation

struct Release: Codable {
    let id: Int
    let title: String
    let year: Int?
    let genre: [String]?
    let label: [String]?
}
