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

// Parse a JSONParsable object
infix operator <*> {}

// Extract an Array of JSONParsable objects
infix operator <|*|> {}

// Extract a Dictionary of JSONParsable objects
infix operator <|*|*|> {}

// Transform a type to another type using a callback
infix operator <<>> { associativity left precedence 160 }

public func <<>><T>(left: AnyObject?, callback: (object: AnyObject?) -> T?) -> T? {
    return callback(object: left)
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

public func <*><T:JSONParsable> (inout left: T, right: AnyObject?) -> T {
    if let dictionary = right as? [String: AnyObject] {
        left = (T.self as T.Type)(JSON: NKJSON(dictionary: dictionary))
    }
    return left
}

public func <*><T:JSONParsable> (inout left: T?, right: AnyObject?) -> T? {
    if let dictionary = right as? [String: AnyObject] {
        left = (T.self as T.Type)(JSON: NKJSON(dictionary: dictionary))
    }
    return left
}

public func <*><T:JSONParsable> (inout left: T!, right: AnyObject?) -> T! {
    if let dictionary = right as? [String: AnyObject] {
        left = (T.self as T.Type)(JSON: NKJSON(dictionary: dictionary))
    }
    return left
}

public func <|*|><T:JSONParsable>(inout left: [T], right: AnyObject?) -> [T] {
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

public func <|*|><T:JSONParsable>(inout left: [T]?, right: AnyObject?) -> [T]? {
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

public func <|*|><T:JSONParsable>(inout left: [T]!, right: AnyObject?) -> [T]! {
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

public func <|*|*|><T:JSONParsable>(inout left: [String: T], right: AnyObject?) ->  [String: T] {
    if let mainDictionary = right as? [String: AnyObject] {
        var allObjects: [String: T] = [:]
        for (key: String, dictionary: AnyObject) in mainDictionary {
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

public func <|*|*|><T:JSONParsable>(inout left: [String: T]?, right: AnyObject?) -> [String: T]? {
    if let mainDictionary = right as? [String: AnyObject] {
        var allObjects: [String: T] = [:]
        for (key: String, dictionary: AnyObject) in mainDictionary {
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

public func <|*|*|><T:JSONParsable>(inout left: [String: T]!, right: AnyObject?) -> [String: T]! {
    if let mainDictionary = right as? [String: AnyObject] {
        var allObjects: [String: T] = [:]
        for (key: String, dictionary: AnyObject) in mainDictionary {
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
    
    public class func parse<T:JSONParsable>(JSONString: String) -> T? {
        return parse(JSONString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true))
    }
    
    public class func parse<T:JSONParsable>(JSONString: String, key: String) -> T? {
        return parse(JSONString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true), key: key)
    }
    
    public class func parse<T:JSONParsable>(JSONString: String) -> [T]? {
        return parse(JSONString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true))
    }
    
    public class func parse<T:JSONParsable>(JSONString: String, key: String) -> [T]? {
        return parse(JSONString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true), key: key)
    }
    
    public class func parse(JSONData: NSData?) -> NKJSON? {
        if let data = JSONData {
            if let result: [String: AnyObject] = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String: AnyObject] {
                return NKJSON(dictionary: result)
            }
        }
        return nil
    }
    
    public class func parse<T:JSONParsable>(JSONData: NSData?) -> T? {
        if let data = JSONData {
            if let result: [String: AnyObject] = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String: AnyObject] {
                return (T.self as T.Type)(JSON: NKJSON(dictionary: result))
            }
        }
        
        return nil
    }
    
    public class func parse<T:JSONParsable>(JSONData: NSData?, key: String) -> T? {
        if let data = JSONData {
            if let result: [String: AnyObject] = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String: AnyObject] {
                let JSON: NKJSON = NKJSON(dictionary: result)
                if let objectInfo = JSON[key] as? [String: AnyObject] {
                    return (T.self as T.Type)(JSON: NKJSON(dictionary: objectInfo))
                }
            }
        }
        
        return nil
    }
    
    public class func parse<T:JSONParsable>(JSONData: NSData?) -> [T]? {
        if let data = JSONData {
            if let result: [AnyObject] = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [AnyObject] {
                var allObjects: [T] = []
                for objectInfo in result as [[String: AnyObject]] {
                    allObjects.append((T.self as T.Type)(JSON: NKJSON(dictionary: objectInfo)))
                }
                return allObjects
            }
        }
        
        return nil
    }
    
    public class func parse<T:JSONParsable>(JSONData: NSData?, key: String) -> [T]? {
        if let data = JSONData {
            if let result: [String: AnyObject] = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String: AnyObject] {
                let JSON: NKJSON = NKJSON(dictionary: result)
                if let objectInfos = JSON[key] as? [[String: AnyObject]] {
                    var allObjects: [T] = []
                    for objectInfo in objectInfos {
                        allObjects.append((T.self as T.Type)(JSON: NKJSON(dictionary: objectInfo)))
                    }
                    return allObjects
                }
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
        
        if let intKey = keys.first?.toInt() {
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

public protocol JSONParsable {
    
    init(JSON: NKJSON)
    
}