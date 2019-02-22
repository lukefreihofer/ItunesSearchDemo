//
//  ViewController+Spinner.swift
//  ItunesSearchDemo
//
//  Created by Luke Freihofer on 2/21/19.
//  Copyright © 2019 Luke Freihofer. All rights reserved.
//

import Foundation
import UIKit

/*
 Taken from here to have easy access to a global spinner
 http://brainwashinc.com/2017/07/21/loading-activity-indicator-ios-swift/
 */


var vSpinner : UIView?

extension UIViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}
