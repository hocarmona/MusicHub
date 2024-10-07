//
//  DiscogsAPIManager.swift
//  MusicHub
//
//  Created by Hector Carmona on 10/6/24.
//


import Foundation

// Definición de los errores de red
enum NetworkError: Error {
    case invalidURL
    case noData
    case invalidResponse
}

class DiscogsAPIManager {
    private let baseURL = "https://api.discogs.com"
    private let token = "FApxJMyYMjGWOBBJwoQiIWVItklsxjaZMaXYxhgH"
    private let userAgent = "MusicHub/1.0"
    
    func searchArtist(query: String, completion: @escaping (Result<[SearchResult], Error>) -> Void) {
        let urlString = "\(baseURL)/database/search?q=\(query)&type=artist"
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

            // Comprobación del código de respuesta HTTP
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
                completion(.success(searchResult.results))  // Devuelve los resultados de búsqueda
            } catch {
                completion(.failure(error))  // Captura cualquier error de decodificación
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

                // Comprobación del código de respuesta HTTP
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
}

