//
//  ItunesSearchResultsDetailsViewController.swift
//  ItunesSearchDemo
//
//  Created by Luke Freihofer on 2/21/19.
//  Copyright © 2019 Luke Freihofer. All rights reserved.
//

import Foundation
import UIKit

class ItunesSearchResultsDetailsViewController : UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var collecName: UILabel!
    @IBOutlet weak var trackPrice: UILabel!
    @IBOutlet weak var collectionPrice: UILabel!
    @IBOutlet weak var descriptionView: UITextView!
    
    var searchResult : Result!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        
        setResultModel(result: searchResult)
    }
    
    func setResultModel(result : Result) {
        let trackPriceString = "Track Price: $\(result.trackPrice ?? 0.00)"
        let collectionPriceString = "Album Price: $\(result.collectionPrice ?? 0.00)"
        
        if let thumbnailurl = result.artworkUrl100 {
            self.imageView.downloaded(from: thumbnailurl)
        }
        
        artistName.text = result.artistName
        trackName.text = result.trackName
        collecName.text = result.collectionName
        trackPrice.text = trackPriceString
        collectionPrice.text = collectionPriceString
        
        switch result.wrapperType {
        case WrapperType.audiobook.rawValue:
            descriptionView.text = result.descriptionField?.htmlToString
        default:
            if result.kind == "feature-movie" {
                descriptionView.text = result.longDescription
            } else {
                descriptionView.text = ""
            }
        }
        
        descriptionView.font = UIFont.systemFont(ofSize: 16)
    }
    
}
