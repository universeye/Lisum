//
//  LookUpResult.swift
//  Lisum
//
//  Created by Terry Kuo on 2023/3/23.
//

import Foundation

struct LookUpResult: Codable {
    struct MediaInfo: Codable {
        let trackName: String
        let artworkUrl100: URL?
        let trackId: Int
        let collectionName: String?
        let artistName: String?
        let kind: String?
        let trackExplicitness: String?
        let artistViewUrl: String?
        let collectionViewUrl: String?
        let previewUrl: String?
        
        private enum CodingKeys: String, CodingKey {
            case trackName
            case artworkUrl100
            case trackId
            case collectionName
            case artistName
            case kind
            case trackExplicitness
            case artistViewUrl
            case collectionViewUrl
            case previewUrl
        }
    }
    
    var resultCount: Int
    var results: [MediaInfo]
}
