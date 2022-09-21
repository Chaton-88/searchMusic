//
//  NetworkDataFetcher.swift
//  searchMusic
//
//  Created by Valeriya Trofimova on 05.06.2022.
//

import Foundation

class NetworkDataFetcher {
    
    let networkService = NetworkService()
    
    func fetchTracks(urlString: String, response: @escaping (SearchResponse?) -> Void) {
        networkService.request(urlString: urlString) { (result) in
            switch result {
            case .success(let data):
                do {
                    let tracks = try JSONDecoder().decode(SearchResponse.self, from: data)
                    //completion(tracks, nil)
                    response(tracks)
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    response(nil)
                    //completion(nil, jsonError)
                }
            case .failure(let error):
                print("Error received requesting data \(error.localizedDescription)")
                response(nil)
            }
        }
    }
}
