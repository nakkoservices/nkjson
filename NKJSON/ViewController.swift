//
//  ViewController.swift
//  NKJSON
//
//  Created by Mihai Fratu on 27/02/15.
//  Copyright (c) 2015 Nakko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var JSONString = "{\"data\": {\"birthDate\": \"19.09.1988\", \"name\": \"Mickey\", \"id\": {\"series\": \"B\", \"number\": 2}, \"parents\": {\"father\": {\"name\": \"Florin\", \"id\": {\"series\": \"B\", \"number\": 0}}}, \"languages\": [\"Romanian\", 123], \"siblings\": [{\"name\": \"Andu\", \"userID\": {\"series\": \"B\", \"number\": 1}}, {\"name\": \"Kitty\", \"id\": {\"series\": \"F\", \"number\": 3}}]}}"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let user: User = NKJSON.parse(JSONString, key: "data") {
            println("Hey \(user.name)! I see you have your ID with you. Series is \(user.id.series) and the number is \(user.id.number)")
            println("Is your birthday today? Oh no! I see you were born on \(user.birthDate)")
            println("It seems like you have \(user.siblings.count) siblings. One is \(user.siblings[0].name) and the other one is \(user.siblings[1].name)")
            println("You can speak \(user.languages.count) languages and by that I mean \(user.languages[0]) and \(user.languages[1]), whatever that is...")
            println("Oh yeah! And your parents are as follows:")
            
            for (parentType, parent) in user.parents {
                println("\(parentType): \(parent.name)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

