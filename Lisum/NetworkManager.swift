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
    
    func searchMusic(for searchTerm: String) async throws -> SearchResult {
        let endpoint = baseURL + "search?term=\(searchTerm)&media=music&limit=200"
        
        guard let url = URL(string: endpoint) else { throw LisumError.invalidSearchTerm }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw LisumError.invalidResponse}
        
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(SearchResult.self, from: data) else { throw LisumError.failedToDecode }
        return decodedData
    }
}
