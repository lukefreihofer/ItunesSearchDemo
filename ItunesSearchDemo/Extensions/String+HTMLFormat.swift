//
//  String+HTMLFormat.swift
//  ItunesSearchDemo
//
//  Created by Luke Freihofer on 2/21/19.
//  Copyright © 2019 Luke Freihofer. All rights reserved.
//

import Foundation

/*
 Taken from here to easily show html text in textfield
 https://stackoverflow.com/questions/37048759/swift-display-html-data-in-a-label-or-textview
 */

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
