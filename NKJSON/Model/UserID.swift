//
//  UserID.swift
//  NKJSON
//
//  Created by Mihai Fratu on 27/02/15.
//  Copyright (c) 2015 Nakko. All rights reserved.
//

import Foundation

class UserID: NKJSONParsable {
    
    var series: String!
    var number: Int = 0
    
    required init(JSON: NKJSON) {
        series <> JSON["series"]
        number <> JSON["number"]
    }
    
}
