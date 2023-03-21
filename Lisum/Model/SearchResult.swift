//
//  SearchResult.swift
//  Lisum
//
//  Created by Terry Kuo on 2023/3/20.
//

import Foundation

struct SearchResult: Codable {
    struct MediaInfo: Codable {
        var trackName: String
        var artworkUrl100: URL?
        var trackId: Int
        var collectionName: String?
        var artistName: String
        
        private enum CodingKeys: String, CodingKey {
            case trackName
            case artworkUrl100
            case trackId
            case collectionName
            case artistName
        }
    }
    
    var resultCount: Int
    var results: [MediaInfo]
}
