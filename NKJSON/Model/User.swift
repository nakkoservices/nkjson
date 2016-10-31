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
    var siblings: [User] = []
    var languages: [AnyObject] = []
    var parents: [String: User] = [:]
    var birthDate: Date?
    var size: CGSize?
    
    required init(JSON: NKJSON) {
        name <> JSON["name"]
        id <> JSON["id"]
        siblings <> JSON["siblings"]
        languages <> JSON["languages"]
        parents <> JSON["parents"]
        birthDate <> JSON["birthDate"] <<>> NKJSON.toDate
        
        size <> JSON["size"] <<>> NKJSON.toCGSize
    }
    
}
