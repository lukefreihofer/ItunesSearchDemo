//
//  ItunesSearchResultsTableViewCell.swift
//  ItunesSearchDemo
//
//  Created by Luke Freihofer on 2/20/19.
//  Copyright © 2019 Luke Freihofer. All rights reserved.
//

import UIKit

class ItunesSearchResultsTableViewCell : UITableViewCell {

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    func setItunesResultModel(result : Result) {
        if let thumbnailUrl = result.artworkUrl100 {
            thumbnail.downloaded(from: thumbnailUrl)
        }
        artistLabel.text = result.artistName
        
        switch result.wrapperType {
            case WrapperType.audiobook.rawValue:
                titleLabel.text = result.collectionName
            default:
                titleLabel.text = result.trackName
        }
    }
}

