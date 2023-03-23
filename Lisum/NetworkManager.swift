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
        let replacedSpaceSearchTerm = searchTerm.replacingOccurrences(of: " ", with: "+")
        let endpoint = baseURL + "search?term=\(replacedSpaceSearchTerm)&media=music&offset=\(offset)&limit=200"
        
        guard let url = URL(string: endpoint) else { throw LisumError.invalidSearchTerm }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw LisumError.invalidResponse}
        
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(SearchResult.self, from: data) else { throw LisumError.failedToDecode }
        return decodedData
    }
    
    func lookUpMusic(for trackId: String) async throws -> SearchResult {
        let endpoint = baseURL + "https://itunes.apple.com/lookup?id=1373858923"
        
        guard let url = URL(string: endpoint) else { throw LisumError.invalidSearchTerm }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw LisumError.invalidResponse}
        
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(SearchResult.self, from: data) else { throw LisumError.failedToDecode }
        return decodedData
    }
}
