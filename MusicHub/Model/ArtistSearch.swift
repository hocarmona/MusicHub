//
//  Artist.swift
//  MusicHub
//
//  Created by Hector Carmona on 10/6/24.
//
import Foundation

// MARK: - ArtistSearch
struct ArtistSearch: Codable {
    let pagination: Pagination
    let results: [SearchResult]
}

// MARK: - Pagination
struct Pagination: Codable {
    let page, pages, perPage, items: Int
    let urls: Urls

    enum CodingKeys: String, CodingKey {
        case page, pages
        case perPage = "per_page"
        case items, urls
    }
}

// MARK: - Urls
struct Urls: Codable {
    let last, next: String
}

// MARK: - SearchResult
struct SearchResult: Codable {
    let id: Int
    let type: TypeEnum
    let userData: UserData
    let masterID, masterURL: JSONNull?
    let uri, title: String
    let thumb: String
    let coverImage: String
    let resourceURL: String

    enum CodingKeys: String, CodingKey {
        case id, type
        case userData = "user_data"
        case masterID = "master_id"
        case masterURL = "master_url"
        case uri, title, thumb
        case coverImage = "cover_image"
        case resourceURL = "resource_url"
    }
}

// MARK: - TypeEnum
enum TypeEnum: String, Codable {
    case artist = "artist"
    case master = "master"
    case release = "release"
}

// MARK: - UserData
struct UserData: Codable {
    let inWantlist, inCollection: Bool

    enum CodingKeys: String, CodingKey {
        case inWantlist = "in_wantlist"
        case inCollection = "in_collection"
    }
}

// MARK: - Encode/decode helpers
class JSONNull: Codable, Hashable {
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
