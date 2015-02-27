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
    
    required init(JSON: NKJSON) {
        name <> JSON["name"]
        id <*> JSON["id"]
    }
    
}