//
//  NetworkManager.swift
//  Lisum
//
//  Created by Terry Kuo on 2023/3/20.
//

import UIKit


class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://itunes.apple.com/"
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func searchMusic(for searchTerm: String, offsetCount offset: Int) async throws -> SearchResult {
        let scheme = "https"
        let host = "itunes.apple.com"
        let path = "/search"
        let queryItemTerm = URLQueryItem(name: "term", value: searchTerm)
        let queryItemOffset = URLQueryItem(name: "offset", value: "\(offset)")
        let queryItemLimit = URLQueryItem(name: "limit", value: "50")
        let queryItemMedia = URLQueryItem(name: "media", value: "music")
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = [queryItemTerm, queryItemMedia, queryItemOffset, queryItemLimit]
        guard let url = urlComponents.url else { throw LisumError.invalidSearchTerm }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            print("error Response: \(response)")
            throw LisumError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(SearchResult.self, from: data) else { throw LisumError.failedToDecode }
        return decodedData
    }
    
    func lookUpMusic(for trackId: String) async throws -> LookUpResult {
        let endpoint = baseURL + "lookup?id=\(trackId)"
        
        guard let url = URL(string: endpoint) else { throw LisumError.invalidSearchTerm }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            print("error Response: \(response)")
            throw LisumError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(LookUpResult.self, from: data) else { throw LisumError.failedToDecode }
        return decodedData
    }
}
