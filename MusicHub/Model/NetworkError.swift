//
//  NetworkError.swift
//  MusicHub
//
//  Created by Hector Carmona on 10/7/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case invalidResponse
}
