//
//  ImageView+Cosmetics.swift
//  ItunesSearchDemo
//
//  Created by Luke Freihofer on 2/21/19.
//  Copyright © 2019 Luke Freihofer. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func roundImageWithBorder() {
        //Makes the imageview into a circle with white border
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
}
