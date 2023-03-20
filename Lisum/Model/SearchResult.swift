//
//  SearchResult.swift
//  Lisum
//
//  Created by Terry Kuo on 2023/3/20.
//

import Foundation

struct SearchResult: Codable {
  struct MediaInfo: Codable {
    var wrapperType: String
    var kind: String
    var artistID: Int
    var collectionID: Date
    var trackID: Date
    var artistName: String
    var collectionName: String
    var trackName: String
    var collectionCensoredName: String
     var artworkUrl100: URL?
   

    private enum CodingKeys: String, CodingKey {
      case wrapperType
      case kind
      case artistID = "artistId"
      case collectionID = "collectionId"
      case trackID = "trackId"
      case artistName
      case collectionName
      case trackName
      case collectionCensoredName
        case artworkUrl100
      
    }
  }

  var resultCount: Int
  var results: [MediaInfo]
}
