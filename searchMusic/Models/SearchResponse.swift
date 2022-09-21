//
//  SearchResponse.swift
//  searchMusic
//
//  Created by Valeriya Trofimova on 04.06.2022.
//

import Foundation

struct SearchResponse: Decodable {
    var resultCount: Int
    var results: [Track]
}

struct Track: Decodable {
    var trackName: String?
    var artistName: String
    var primaryGenreName: String
    var artworkUrl60: String?
}
