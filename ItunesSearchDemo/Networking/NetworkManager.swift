//
//  Networking.swift
//  ItunesSearchDemo
//
//  Created by Luke Freihofer on 2/20/19.
//  Copyright © 2019 Luke Freihofer. All rights reserved.
//

import Foundation

class NetworkManager {

    static let shared = NetworkManager()
    private let searchAPI = "https://itunes.apple.com/search?term="

    func searchItunes(searchTerms : String, completion : @escaping (ItunesSearchResults) -> ()) {
        
        guard let searchUrl = URL(string: searchAPI + searchTerms) else { return }
        
        URLSession.shared.dataTask(with: searchUrl) {(data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            do {
                let resultData = try JSONDecoder().decode(ItunesSearchResults.self, from: data)
                completion(resultData)
            } catch let err {
                print(err)
            }
            
            
        }.resume()
    }
    
}
