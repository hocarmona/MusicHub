//
//  ArtistDetails.swift
//  MusicHub
//
//  Created by Hector Carmona on 10/6/24.
//

import Foundation

//MARK: - ArtistMoreDetails
struct ArtistMoreDetails: Codable {
    let name: String
    let id: Int
    let resourceURL, uri, releasesURL: String
    let images: [Image]?
    let profile: String?
    let urls: [String]?
    let namevariations: [String]?
    let aliases, members: [Alias]?
    let dataQuality: String?

    enum CodingKeys: String, CodingKey {
        case name, id
        case resourceURL = "resource_url"
        case uri
        case releasesURL = "releases_url"
        case images, profile, urls, namevariations, aliases, members
        case dataQuality = "data_quality"
    }
}

// MARK: - Alias
struct Alias: Codable {
    let id: Int
    let name: String
    let resourceURL: String?
    let thumbnailURL: String?
    let active: Bool?

    enum CodingKeys: String, CodingKey {
        case id, name
        case resourceURL = "resource_url"
        case thumbnailURL = "thumbnail_url"
        case active
    }
}

// MARK: - Image
struct Image: Codable {
    let type: String?
    let uri, resourceURL, uri150: String?
    let width, height: Int?

    enum CodingKeys: String, CodingKey {
        case type, uri
        case resourceURL = "resource_url"
        case uri150, width, height
    }
}
