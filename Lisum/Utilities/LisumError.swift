//
//  LisumError.swift
//  Lisum
//
//  Created by Terry Kuo on 2023/3/20.
//

import Foundation

enum LisumError:  String, Error {
    case invalidSearchTerm = "This search term created an Invalid request."
    case unableToComplete = "Unable to complete your requst, please try again later."
    case invalidResponse = "Invalid response from the server , please check the search term."
    case invalidData = "The data from the server recieved was invalid."
    case failedToDecode = "Decoding Falied."
}
