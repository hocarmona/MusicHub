//
//  DiscogsAPIManager.swift
//  MusicHub
//
//  Created by Hector Carmona on 10/6/24.
//


import Foundation

class DiscogsAPIManager: DiscogsAPIManagerProtocol {
    private let baseURL = "https://api.discogs.com"
    private let token = "FApxJMyYMjGWOBBJwoQiIWVItklsxjaZMaXYxhgH"
    private let userAgent = "MusicHub/1.0"
    
    func searchArtist(query: String, page: Int = 1, itemsPerPage: Int = 30, completion: @escaping (Result<ArtistSearch, Error>) -> Void) {
        let urlString = "\(baseURL)/database/search?q=\(query)&type=artist&page=\(page)&per_page=\(itemsPerPage)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.addValue("Discogs token=\(token)", forHTTPHeaderField: "Authorization")
        request.addValue(userAgent, forHTTPHeaderField: "User-Agent")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            do {
                let searchResult = try JSONDecoder().decode(ArtistSearch.self, from: data)
                completion(.success(searchResult))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchArtistDetails(artistId: Int, completion: @escaping (Result<ArtistMoreDetails, Error>) -> Void) {
        let urlString = "\(baseURL)/artists/\(artistId)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.addValue("Discogs token=\(token)", forHTTPHeaderField: "Authorization")
        request.addValue(userAgent, forHTTPHeaderField: "User-Agent")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            do {
                let artistDetails = try JSONDecoder().decode(ArtistMoreDetails.self, from: data)
                completion(.success(artistDetails))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchArtistReleases(artistId: Int, page: Int = 1, completion: @escaping (Result<ArtistAlbums, Error>) -> Void) {
        let urlString = "\(baseURL)/artists/\(artistId)/releases?page=\(page)&per_page=30"
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.addValue("Discogs token=\(token)", forHTTPHeaderField: "Authorization")
        request.addValue(userAgent, forHTTPHeaderField: "User-Agent")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            do {
                let artistAlbums = try JSONDecoder().decode(ArtistAlbums.self, from: data)
                completion(.success(artistAlbums))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }


}

protocol DiscogsAPIManagerProtocol {
    func searchArtist(query: String, page: Int, itemsPerPage: Int, completion: @escaping (Result<ArtistSearch, Error>) -> Void)
    func fetchArtistDetails(artistId: Int, completion: @escaping (Result<ArtistMoreDetails, Error>) -> Void)
    func fetchArtistReleases(artistId: Int, page: Int, completion: @escaping (Result<ArtistAlbums, Error>) -> Void)
}
