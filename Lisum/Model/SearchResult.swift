//
//  SearchResult.swift
//  Lisum
//
//  Created by Terry Kuo on 2023/3/20.
//

import Foundation

struct SearchResult: Codable {
    struct MediaInfo: Codable {
        let trackName: String
        let artworkUrl100: URL?
        let trackId: Int
        let collectionName: String?
        let artistName: String?
        let kind: String?
        let trackExplicitness: String?
        
        private enum CodingKeys: String, CodingKey {
            case trackName
            case artworkUrl100
            case trackId
            case collectionName
            case artistName
            case kind
            case trackExplicitness
        }
    }
    
    var resultCount: Int
    var results: [MediaInfo]
}
