//
//  User.swift
//  NKJSON
//
//  Created by Mihai Fratu on 27/02/15.
//  Copyright (c) 2015 Nakko. All rights reserved.
//

import UIKit

class User: NKJSONParsable {
    
    var name: String!
    var id: UserID!
    var siblings: [User]!
    var languages: [AnyObject]!
    var parents: [String: User]!
    var birthDate: NSDate!
    var size: CGSize!
    
    func dateFormatter(object: AnyObject?) -> NSDate? {
        if let dateString = object as? String {
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale.systemLocale()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            return dateFormatter.dateFromString(dateString)
        }
        return nil
    }
    
    func toCGSize(object: AnyObject?) -> CGSize? {
        if let dictionary = object as? [String: CGFloat] {
            if let width = dictionary["width"] {
                if let height = dictionary["height"] {
                    return CGSizeMake(width, height)
                }
            }
        }
        return nil
    }
    
    required init(JSON: NKJSON) {
        name <> JSON["name"]
        id <*> JSON["id"]
        siblings <|*|> JSON["siblings"]
        languages <> JSON["languages"]
        parents <|*|*|> JSON["parents"]
        birthDate <> JSON["birthDate"] <<>> dateFormatter
        
        
        print(self.name)
        print(JSON["size"])
        size <> JSON["size"] <<>> toCGSize
    }
    
}