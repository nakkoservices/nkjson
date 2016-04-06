//
//  NKJSON.swift
//  NKJSON
//
//  Created by Mihai Fratu on 27/02/15.
//  Copyright (c) 2015 Nakko. All rights reserved.
//

import Foundation
import UIKit

private let dotReplacement = "_|_DOT_|_"

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
        if let object = (T.self as T.Type).init(JSON: NKJSON(dictionary: dictionary)) {
            left = object
        }
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
    
    // MARK: - Public class vars
    
    public class var rootKey: String {
        return "__root"
    }
    
    public static var dateFormat: String = "YYYY-MM-dd'T'HH:mm:ssZZZZZ"
    
    // MARK: - Private instance vars
    
    private var resultDictionary: [String: AnyObject]! = nil
    
    // MARK: - Public class methods
    
    public class func parse(JSONString: String) -> NKJSON? {
        return parse(JSONString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true))
    }
    
    public class func parse<T:NKJSONParsable>(JSONString: String, key: String? = nil) -> T? {
        return parse(JSONString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true), key: key)
    }
    
    public class func parse<T:NKJSONParsable>(JSONString: String, key: String? = nil) -> [T]? {
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
    
    public class func parse<T:NKJSONParsable>(JSONData: NSData?, key: String? = nil) -> T? {
        if let data = JSONData {
            do {
                if let result: [String: AnyObject] = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject] {
                    guard let key = key else {
                        return (T.self as T.Type).init(JSON: NKJSON(dictionary: result))
                    }
                    
                    let JSON: NKJSON = NKJSON(dictionary: result)
                    if let object = JSON[key] as? T {
                        return object
                    }
                    else if let objectInfo = JSON[key] as? [String: AnyObject] {
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
    
    public class func parse<T:NKJSONParsable>(JSONData: NSData?, key: String? = nil) -> [T]? {
        if let data = JSONData {
            do {
                guard let key = key else {
                    if let result: [[String: AnyObject]] = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [[String: AnyObject]] {
                        var allObjects: [T] = []
                        for objectInfo in result {
                            if let object = (T.self as T.Type).init(JSON: NKJSON(dictionary: objectInfo)) {
                                allObjects.append(object)
                            }
                        }
                        return allObjects
                    }
                    return nil
                }
                
                if let result: [String: AnyObject] = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject] {
                    let JSON: NKJSON = NKJSON(dictionary: result)
                    if let objectInfos = JSON[key] as? [[String: AnyObject]] {
                        var allObjects: [T] = []
                        for objectInfo in objectInfos {
                            if let object = (T.self as T.Type).init(JSON: NKJSON(dictionary: objectInfo))
                            {
                                allObjects.append(object)
                            }
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
    
    public class func parseFile<T:NKJSONParsable>(filePath: String, key: String? = nil) -> T? {
        do {
            return parse(try String(contentsOfFile: filePath), key: key)
        }
        catch {
            return nil
        }
    }
    
    public class func parseFile<T:NKJSONParsable>(filePath: String, key: String? = nil) -> [T]? {
        do {
            return parse(try String(contentsOfFile: filePath), key: key)
        }
        catch {
            return nil
        }
    }
    
    public init(dictionary: [String: AnyObject]) {
        resultDictionary = dictionary
    }
    
    // MARK: - Private instance methods
    
    private func getValue(keys: [String], array: [AnyObject]) -> AnyObject? {
        if keys.isEmpty {
            return nil
        }
        
        if let intKey = Int(keys.first!) {
            if array.count <= intKey || intKey < 0 {
                return nil
            }
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
        
        let currentKey = (keys.first! as String).stringByReplacingOccurrencesOfString(dotReplacement, withString: ".")
        if keys.count > 1 {
            if let newDictionary = dictionary[currentKey] as? [String: AnyObject] {
                return getValue(Array(keys[1..<keys.count]), dictionary: newDictionary)
            }
            else {
                if let newArray = dictionary[currentKey] as? [AnyObject] {
                    return getValue(Array(keys[1..<keys.count]), array: newArray)
                }
            }
        }
        else {
            return dictionary[currentKey]
        }
        
        return nil
    }
    
    public subscript(key: String) -> AnyObject? {
        if key == NKJSON.rootKey {
            return resultDictionary
        }
        
        let finalKey = (key as String).stringByReplacingOccurrencesOfString("\\.", withString: dotReplacement)
        return getValue(finalKey.componentsSeparatedByString("."), dictionary: resultDictionary)
    }
    
    public subscript(keys: [String]) -> AnyObject? {
        for key in keys {
            guard let value = self[key] else {
                continue
            }
            return value
        }
        return nil
    }
    
    // MARK: - Helper methods
    
    public class func toInt(object: AnyObject?) -> Int? {
        guard let int = object as? Int else {
            guard let intString = object as? NSString else {
                return nil
            }
            return intString.integerValue
        }
        return int
    }
    
    public class func toFloat(object: AnyObject?) -> Float? {
        guard let float = object as? Float else {
            guard let floatString = object as? NSString else {
                return nil
            }
            return floatString.floatValue
        }
        return float
    }
    
    public class func toBool(object: AnyObject?) -> Bool? {
        guard let bool = object as? Bool else {
            guard let boolString = object as? NSString else {
                return nil
            }
            
            return boolString.boolValue
        }
        
        return bool
    }
    
    public class func toCGFloat(object: AnyObject?) -> CGFloat? {
        guard let float = toFloat(object) else {
            return nil
        }
        return CGFloat(float)
    }
    
    public class func toCGSize(object: AnyObject?) -> CGSize? {
        guard let dictionary = object as? [String: CGFloat] else {
            guard let dictionary = object as? [String: NSString] else {
                return nil
            }
            
            guard let width = dictionary["width"] else {
                return nil
            }
            
            guard let height = dictionary["height"] else {
                return nil
            }
            
            return CGSizeMake(CGFloat(width.floatValue), CGFloat(height.floatValue))
        }
        
        guard let width = dictionary["width"] else {
            return nil
        }
        
        guard let height = dictionary["height"] else {
            return nil
        }
        
        return CGSizeMake(width, height)
    }
    
    public class func toCGPoint(object: AnyObject?) -> CGPoint? {
        guard let dictionary = object as? [String: CGFloat] else {
            guard let dictionary = object as? [String: NSString] else {
                return nil
            }
            
            guard let x = dictionary["x"] else {
                return nil
            }
            
            guard let y = dictionary["y"] else {
                return nil
            }
            
            return CGPointMake(CGFloat(x.floatValue), CGFloat(y.floatValue))
        }
        
        guard let x = dictionary["x"] else {
            return nil
        }
        
        guard let y = dictionary["y"] else {
            return nil
        }
        
        return CGPointMake(x, y)
    }
    
    public class func toDate(object: AnyObject?) -> NSDate? {
        guard let dateString = object as? String else {
            return nil
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(abbreviation: "CET")!
        dateFormatter.dateFormat = dateFormat
        
        guard let date = dateFormatter.dateFromString(dateString) else {
            return dateString.detectDates()?.first
        }
        
        return date
    }
    
    public class func toNilIfEmpty(object: AnyObject?) -> String? {
        guard let string = (object as? String)?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) else {
            return nil
        }
        return string.characters.count > 0 ? string : nil
    }
    
}

public protocol NKJSONParsable {
    
    init?(JSON: NKJSON)
    
}

extension String {
    
    func detectDates() -> [NSDate]? {
        do {
            return try NSDataDetector(types: NSTextCheckingType.Date.rawValue)
                .matchesInString(self, options: [], range: NSRange(0..<characters.count))
                .filter{$0.resultType == .Date}
                .flatMap{$0.date}
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
    
}