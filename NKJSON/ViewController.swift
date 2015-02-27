//
//  ViewController.swift
//  NKJSON
//
//  Created by Mihai Fratu on 27/02/15.
//  Copyright (c) 2015 Nakko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var JSONString = "{\"data\": {\"name\": \"Mickey\", \"userID\": {\"series\": \"B\", \"number\": 2}, \"parents\": {\"father\": {\"name\": \"Florin\", \"userID\": {\"series\": \"B\", \"number\": 0}}}, \"languages\": [\"Romanian\", 123], \"brothers\": [{\"name\": \"Andu\", \"userID\": {\"series\": \"B\", \"number\": 1}}, {\"name\": \"Kitty\", \"userID\": {\"series\": \"F\", \"number\": 3}}], \"test\": [\"Test 1\", \"Test 2\", [\"Test 3\", {\"test\": \"Awesome!\"}]]}}"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let user: User = NKJSON.parse(JSONString, key: "data") {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

