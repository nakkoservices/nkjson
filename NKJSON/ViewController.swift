//
//  ViewController.swift
//  NKJSON
//
//  Created by Mihai Fratu on 27/02/15.
//  Copyright (c) 2015 Nakko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var JSONString = "{\"data\": {\"size\": {\"width\": 200, \"height\": 100} , \"birthDate\": \"19.09.1988\", \"name\": \"Mickey\", \"id\": {\"series\": \"B\", \"number\": 2}, \"parents\": {\"mother\": {\"name\": \"Cătălina\", \"id\": {\"series\": \"B\", \"number\": 0}}, \"father\": {\"name\": \"Florin\", \"id\": {\"series\": \"B\", \"number\": 0}}}, \"languages\": [\"Romanian\", 123], \"siblings\": [{\"name\": \"Andu\", \"userID\": {\"series\": \"B\", \"number\": 1}}, {\"name\": \"Kitty\", \"id\": {\"series\": \"F\", \"number\": 3}}]}}"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let user: User = NKJSON.parse(JSONString, key: "data") {
            print("Hey \(user.name)! I see you have your ID with you. Series is \(user.id.series) and the number is \(user.id.number)")
            let birthDayString = user.birthDate ?? Date()
            print("Is your birthday today? Oh no! I see you were born on \(birthDayString)")
            print("It seems like you have \(user.siblings.count) siblings. One is \(user.siblings[0].name) and the other one is \(user.siblings[1].name)")
            print("You can speak \(user.languages.count) languages and by that I mean \(user.languages[0]) and \(user.languages[1]), whatever that is...")
            print("Oh yeah! And your parents are as follows:")
            
            for (parentType, parent) in user.parents {
                print("\(parentType): \(parent.name)")
            }
        }
        else {
            print("Could not parse!")
        }
        
        if let brother: User = NKJSON.parse(JSONString, key: "data.siblings.0") {
            print("Brother's name is \(brother.name)")
        }
        else {
            print("Could not parse!")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

