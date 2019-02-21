//
//  ItunesSearchResults.swift
//  ItunesSearchDemo
//
//  Created by Luke Freihofer on 2/20/19.
//  Copyright © 2019 Luke Freihofer. All rights reserved.
//

import Foundation

enum WrapperType : String {
    case audiobook = "audiobook"
    case track = "track"
}

struct ItunesSearchResults : Codable {
    let resultCount : Int?
    let results : [Result]?
    
    enum CodingKeys: String, CodingKey {
        case resultCount = "resultCount"
        case results = "results"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        resultCount = try values.decodeIfPresent(Int.self, forKey: .resultCount)
        results = try values.decodeIfPresent([Result].self, forKey: .results)
    }
}
