//
//  LookUpResult.swift
//  Lisum
//
//  Created by Terry Kuo on 2023/3/23.
//

import Foundation

struct LookUpResult: Codable {
    struct MediaInfo: Codable {
        var trackName: String
        var artworkUrl100: URL?
        var trackId: Int
        var collectionName: String?
        var artistName: String?
        var kind: String?
        var trackExplicitness: String?
        
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
