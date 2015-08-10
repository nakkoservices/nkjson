//
//  NKJSON.swift
//  NKJSON
//
//  Created by Mihai Fratu on 27/02/15.
//  Copyright (c) 2015 Nakko. All rights reserved.
//

import Foundation

// Extract a Foundation object
infix operator <> {}

// Parse a NKJSONParsable object
infix operator <*> {}

// Extract an Array of NKJSONParsable objects
infix operator <|*|> {}

// Extract a Dictionary of NKJSONParsable objects
infix operator <|*|*|> {}

// Transform a type to another type using a callback
infix operator <<>> { associativity left precedence 160 }

public func <<>><T>(left: AnyObject?, callback: (object: AnyObject?) -> T?) -> T? {
    return callback(object: left)
}

public func <><T> (inout left: T, right: Any?) -> T {
    if let value = right as? T {
        left = value
    }
    return left
}

public func <><T> (inout left: T?, right: Any?) -> T? {
    if let value = right as? T {
        left = value
    }
    return left
}

public func <><T> (inout left: T!, right: Any?) -> T! {
    if let value = right as? T {
        left = value
    }
    return left
}

public func <><T> (inout left: T, right: AnyObject?) -> T {
    if let value = right as? T {
        left = value
    }
    return left
}

public func <><T> (inout left: T?, right: AnyObject?) -> T? {
    if let value = right as? T {
        left = value
    }
    return left
}

public func <><T> (inout left: T!, right: AnyObject?) -> T! {
    if let value = right as? T {
        left = value
    }
    return left
}

public func <*><T:NKJSONParsable> (inout left: T, right: AnyObject?) -> T {
    if let dictionary = right as? [String: AnyObject] {
        left = (T.self as T.Type).init(JSON: NKJSON(dictionary: dictionary))
    }
    return left
}

public func <*><T:NKJSONParsable> (inout left: T?, right: AnyObject?) -> T? {
    if let dictionary = right as? [String: AnyObject] {
        left = (T.self as T.Type).init(JSON: NKJSON(dictionary: dictionary))
    }
    return left
}

public func <*><T:NKJSONParsable> (inout left: T!, right: AnyObject?) -> T! {
    if let dictionary = right as? [String: AnyObject] {
        left = (T.self as T.Type).init(JSON: NKJSON(dictionary: dictionary))
    }
    return left
}

public func <|*|><T:NKJSONParsable>(inout left: [T], right: AnyObject?) -> [T] {
    if let array = right as? [AnyObject] {
        var allObjects = Array<T>()
        for dictionary in array {
            var object: T!
            object <*> dictionary
            if object != nil {
                allObjects.append(object)
            }
        }
        left = allObjects
    }
    
    return left
}

public func <|*|><T:NKJSONParsable>(inout left: [T]?, right: AnyObject?) -> [T]? {
    if let array = right as? [AnyObject] {
        var allObjects = Array<T>()
        for dictionary in array {
            var object: T!
            object <*> dictionary
            if object != nil {
                allObjects.append(object)
            }
        }
        left = allObjects
    }
    
    return left
}

public func <|*|><T:NKJSONParsable>(inout left: [T]!, right: AnyObject?) -> [T]! {
    if let array = right as? [AnyObject] {
        var allObjects = Array<T>()
        for dictionary in array {
            var object: T!
            object <*> dictionary
            if object != nil {
                allObjects.append(object)
            }
        }
        left = allObjects
    }
    
    return left
}

public func <|*|*|><T:NKJSONParsable>(inout left: [String: T], right: AnyObject?) ->  [String: T] {
    if let mainDictionary = right as? [String: AnyObject] {
        var allObjects: [String: T] = [:]
        for (key, dictionary): (String, AnyObject) in mainDictionary {
            var object: T!
            object <*> dictionary
            if object != nil {
                allObjects[key] = object
            }
        }
        left = allObjects
    }
    
    return left
}

public func <|*|*|><T:NKJSONParsable>(inout left: [String: T]?, right: AnyObject?) -> [String: T]? {
    if let mainDictionary = right as? [String: AnyObject] {
        var allObjects: [String: T] = [:]
        for (key, dictionary): (String, AnyObject) in mainDictionary {
            var object: T!
            object <*> dictionary
            if object != nil {
                allObjects[key] = object
            }
        }
        left = allObjects
    }
    
    return left
}

public func <|*|*|><T:NKJSONParsable>(inout left: [String: T]!, right: AnyObject?) -> [String: T]! {
    if let mainDictionary = right as? [String: AnyObject] {
        var allObjects: [String: T] = [:]
        for (key, dictionary): (String, AnyObject) in mainDictionary {
            var object: T!
            object <*> dictionary
            if object != nil {
                allObjects[key] = object
            }
        }
        left = allObjects
    }
    
    return left
}

public class NKJSON {
    
    private var resultDictionary: [String: AnyObject]! = nil
    
    public class var rootKey: String {
        return "__root"
    }
    
    public class func parse(JSONString: String) -> NKJSON? {
        return parse(JSONString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true))
    }
    
    public class func parse<T:NKJSONParsable>(JSONString: String) -> T? {
        return parse(JSONString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true))
    }
    
    public class func parse<T:NKJSONParsable>(JSONString: String, key: String) -> T? {
        return parse(JSONString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true), key: key)
    }
    
    public class func parse<T:NKJSONParsable>(JSONString: String) -> [T]? {
        return parse(JSONString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true))
    }
    
    public class func parse<T:NKJSONParsable>(JSONString: String, key: String) -> [T]? {
        return parse(JSONString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true), key: key)
    }
    
    public class func parse(JSONData: NSData?) -> NKJSON? {
        if let data = JSONData {
            do {
                if let result: [String: AnyObject] = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject] {
                    return NKJSON(dictionary: result)
                }
            }
            catch {
                return nil
            }
        }
        return nil
    }
    
    public class func parse<T:NKJSONParsable>(JSONData: NSData?) -> T? {
        if let data = JSONData {
            do {
                if let result: [String: AnyObject] = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject] {
                    return (T.self as T.Type).init(JSON: NKJSON(dictionary: result))
                }
            }
            catch {
                return nil
            }
        }
        
        return nil
    }
    
    public class func parse<T:NKJSONParsable>(JSONData: NSData?, key: String) -> T? {
        if let data = JSONData {
            do {
                if let result: [String: AnyObject] = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject] {
                    let JSON: NKJSON = NKJSON(dictionary: result)
                    if let objectInfo = JSON[key] as? [String: AnyObject] {
                        return (T.self as T.Type).init(JSON: NKJSON(dictionary: objectInfo))
                    }
                }
            }
            catch {
                return nil
            }
        }
        
        return nil
    }
    
    public class func parse<T:NKJSONParsable>(JSONData: NSData?) -> [T]? {
        if let data = JSONData {
            do {
                if let result: [[String: AnyObject]] = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [[String: AnyObject]] {
                    var allObjects: [T] = []
                    for objectInfo in result {
                        allObjects.append((T.self as T.Type).init(JSON: NKJSON(dictionary: objectInfo)))
                    }
                    return allObjects
                }
            }
            catch {
                return nil
            }
        }
        
        return nil
    }
    
    public class func parse<T:NKJSONParsable>(JSONData: NSData?, key: String) -> [T]? {
        if let data = JSONData {
            do {
                if let result: [String: AnyObject] = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject] {
                    let JSON: NKJSON = NKJSON(dictionary: result)
                    if let objectInfos = JSON[key] as? [[String: AnyObject]] {
                        var allObjects: [T] = []
                        for objectInfo in objectInfos {
                            allObjects.append((T.self as T.Type).init(JSON: NKJSON(dictionary: objectInfo)))
                        }
                        return allObjects
                    }
                }
            }
            catch {
                return nil
            }
        }
        
        return nil
    }
    
    private init(dictionary: [String: AnyObject]) {
        resultDictionary = dictionary
    }
    
    private func getValue(keys: [String], array: [AnyObject]) -> AnyObject? {
        if keys.isEmpty {
            return nil
        }
        
        if let intKey = Int(keys.first!) {
            if keys.count > 1 {
                if let newDictionary = array[intKey] as? [String: AnyObject] {
                    return getValue(Array(keys[1..<keys.count]), dictionary: newDictionary)
                }
                else {
                    if let newArray = array[intKey] as? [AnyObject] {
                        return getValue(Array(keys[1..<keys.count]), array: newArray)
                    }
                }
            }
            else {
                return array[intKey]
            }
        }
        
        return nil
    }
    
    private func getValue(keys: [String], dictionary: [String: AnyObject]) -> AnyObject? {
        if keys.isEmpty {
            return nil
        }
        
        if keys.count > 1 {
            if let newDictionary = dictionary[keys.first!] as? [String: AnyObject] {
                return getValue(Array(keys[1..<keys.count]), dictionary: newDictionary)
            }
            else {
                if let newArray = dictionary[keys.first!] as? [AnyObject] {
                    return getValue(Array(keys[1..<keys.count]), array: newArray)
                }
            }
        }
        else {
            return dictionary[keys.first!]
        }
        
        return nil
    }
    
    public subscript(key: String) -> AnyObject? {
        if key == NKJSON.rootKey {
            return resultDictionary
        }
        
        return getValue(key.componentsSeparatedByString("."), dictionary: resultDictionary)
    }
    
}

public protocol NKJSONParsable {
    
    init(JSON: NKJSON)
    
}