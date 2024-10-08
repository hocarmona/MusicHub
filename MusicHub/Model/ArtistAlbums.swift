//
//  Release.swift
//  MusicHub
//
//  Created by Hector Carmona on 10/6/24.
//

import Foundation

struct ArtistAlbums: Codable {
    let pagination: Pagination
    var releases: [Release]
}


// MARK: - Release
struct Release: Codable {
    let id: Int
    let status: Status?
    let type: TypeEnum
    let format, label: String?
    let title: String
    let resourceURL: String?
    let role: Role?
    let artist: String?
    let year: Int?
    let thumb: String?
    let stats: Stats?
    let mainRelease: Int?

    enum CodingKeys: String, CodingKey {
        case id, status, type, format, label, title
        case resourceURL = "resource_url"
        case role, artist, year, thumb, stats
        case mainRelease = "main_release"
    }
}

enum Role: String, Codable {
    case main = "Main"
}

// MARK: - Stats
struct Stats: Codable {
    let community: Community?
    let user: Community?
}

// MARK: - Community
struct Community: Codable {
    let inWantlist, inCollection: Int?

    enum CodingKeys: String, CodingKey {
        case inWantlist = "in_wantlist"
        case inCollection = "in_collection"
    }
}

enum Status: String, Codable {
    case accepted = "Accepted"
}

