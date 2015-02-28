//
//  User.swift
//  NKJSON
//
//  Created by Mihai Fratu on 27/02/15.
//  Copyright (c) 2015 Nakko. All rights reserved.
//

import Foundation

class User: JSONParsable {
    
    var name: String!
    var id: UserID!
    var siblings: [User]!
    var languages: [AnyObject]!
    var parents: [String: User]!
    var birthDate: NSDate!
    
    func dateFormatter(object: AnyObject?) -> NSDate? {
        if let dateString = object as? String {
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale.systemLocale()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            return dateFormatter.dateFromString(dateString)
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
    }
    
}