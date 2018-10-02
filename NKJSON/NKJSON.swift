//
//  NKJSON.swift
//  NKJSON
//
//  Created by Mihai Fratu on 27/02/15.
//  Copyright (c) 2015 Nakko. All rights reserved.
//

import Foundation
#if os(OSX)
    import AppKit
#else
    import UIKit
#endif

private let dotReplacement = "_|_DOT_|_"

// Extract a Foundation object
infix operator <> : NKJSONDefaultPrecedence

// Transform a type to another type using a callback
infix operator <<>> : NKJSONTransformPrecedence

public func <<>><T>(left: AnyObject?, callback: (AnyObject?) -> T?) -> T? {
    return callback(left)
}

precedencegroup NKJSONDefaultPrecedence {
    higherThan: BitwiseShiftPrecedence
}

precedencegroup NKJSONTransformPrecedence {
    associativity: left
    higherThan: NKJSONDefaultPrecedence
}

public func <><T> (left: inout T, right: Any?) {
    if let value = right as? T {
        left = value
    }
}

public func <><T> (left: inout T?, right: Any?) {
    if let value = right as? T {
        left = value
    }
}

public func <><T> (left: inout T, right: AnyObject?) {
    if let value = right as? T {
        left = value
    }
}

public func <><T> (left: inout T?, right: AnyObject?) {
    if let value = right as? T? {
        left = value
    }
}

public func <><T:NKJSONParsable> (left: inout T, right: AnyObject?) {
    if let dictionary = right as? [String: AnyObject] {
        if let object = (T.self as T.Type).init(JSON: NKJSON(dictionary: dictionary)) {
            left = object
        }
    }
}

public func <><T:NKJSONParsable> (left: inout T?, right: AnyObject?) {
    if let dictionary = right as? [String: AnyObject] {
        left = (T.self as T.Type).init(JSON: NKJSON(dictionary: dictionary))
    }
}

public func <><T:NKJSONParsable>(left: inout [T], right: AnyObject?) {
    if let array = right as? [AnyObject] {
        var allObjects = Array<T>()
        for dictionary in array {
            var object: T!
            object <> dictionary
            if object != nil {
                allObjects.append(object)
            }
        }
        left = allObjects
    }
    
}

public func <><T:NKJSONParsable>(left: inout [T]?, right: AnyObject?) {
    if let array = right as? [AnyObject] {
        var allObjects = Array<T>()
        for dictionary in array {
            var object: T!
            object <> dictionary
            if object != nil {
                allObjects.append(object)
            }
        }
        left = allObjects
    }
}

public func <><T:NKJSONParsable>(left: inout [String: T], right: AnyObject?) {
    if let mainDictionary = right as? [String: AnyObject] {
        var allObjects: [String: T] = [:]
        for (key, dictionary): (String, AnyObject) in mainDictionary {
            var object: T!
            object <> dictionary
            if object != nil {
                allObjects[key] = object
            }
        }
        left = allObjects
    }
}

public func <><T:NKJSONParsable>(left: inout [String: T]?, right: AnyObject?) {
    if let mainDictionary = right as? [String: AnyObject] {
        var allObjects: [String: T] = [:]
        for (key, dictionary): (String, AnyObject) in mainDictionary {
            var object: T!
            object <> dictionary
            if object != nil {
                allObjects[key] = object
            }
        }
        left = allObjects
    }
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
    
    public class func parse(_ JSONString: String) -> NKJSON? {
        return parse(JSONString.data(using: .utf8, allowLossyConversion: true) as Data?)
    }
    
    public class func parse<T:NKJSONParsable>(_ JSONString: String, key: String? = nil) -> T? {
        return parse(JSONString.data(using: .utf8, allowLossyConversion: true) as Data?, key: key)
    }
    
    public class func parse<T:NKJSONParsable>(_ JSONString: String, key: String? = nil) -> [T]? {
        return parse(JSONString.data(using: .utf8, allowLossyConversion: true) as Data?, key: key)
    }
    
    public class func parse(_ JSONData: Data?) -> NKJSON? {
        if let data = JSONData {
            do {
                if let result: [String: AnyObject] = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                    return NKJSON(dictionary: result)
                }
            }
            catch {
                return nil
            }
        }
        return nil
    }
    
    public class func parse<T:NKJSONParsable>(_ JSONData: Data?, key: String? = nil) -> T? {
        if let data = JSONData {
            do {
                if let result: [String: AnyObject] = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
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
    
    public class func parse<T:NKJSONParsable>(_ JSONData: Data?, key: String? = nil) -> [T]? {
        if let data = JSONData {
            do {
                guard let key = key else {
                    if let result: [[String: AnyObject]] = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: AnyObject]] {
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
                
                if let result: [String: AnyObject] = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
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
    
    public class func parseFile<T:NKJSONParsable>(_ filePath: String, key: String? = nil) -> T? {
        do {
            return parse(try String(contentsOfFile: filePath), key: key)
        }
        catch {
            return nil
        }
    }
    
    public class func parseFile<T:NKJSONParsable>(_ filePath: String, key: String? = nil) -> [T]? {
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
                    return getValue(keys: Array(keys[1..<keys.count]), dictionary: newDictionary)
                }
                else {
                    if let newArray = array[intKey] as? [AnyObject] {
                        return getValue(keys: Array(keys[1..<keys.count]), array: newArray)
                    }
                }
            }
            else {
                return array[intKey]
            }
        }
        
        return nil
    }
    
    private func getValue(keys: [String], array: [AnyObject], keyName: String, keyValue: String, valueKey: String) -> AnyObject? {
        if keys.isEmpty {
            return nil
        }
        
        
        
        return nil
    }
    
    private func getValue(keys: [String], dictionary: [String: AnyObject]) -> AnyObject? {
        if keys.isEmpty {
            return nil
        }
        
        var currentKey = (keys.first! as String).replacingOccurrences(of: dotReplacement, with: ".")
        
        do {
            let regEx = try NSRegularExpression(pattern: "(.*?)(?:\\[(.*?)\\=(.*?)\\|(.*?)\\]|$)")
            let result = regEx.firstMatch(in: currentKey, options: [], range: NSMakeRange(0, currentKey.count))!
            if result.range(at: 2).location == NSNotFound  {
                if keys.count > 1 {
                    if let newDictionary = dictionary[currentKey] as? [String: AnyObject] {
                        return getValue(keys: Array(keys[1..<keys.count]), dictionary: newDictionary)
                    }
                    else {
                        if let newArray = dictionary[currentKey] as? [AnyObject] {
                            if keys[1] == "[*]" {
                                var values: [AnyObject] = []
                                for value in newArray {
                                    guard let dictionary = getValue(keys: Array(keys[2..<keys.count]), dictionary: value as! [String : AnyObject]) else {
                                        continue
                                    }
                                    values.append(dictionary)
                                }
                                return values as NSArray
                            }
                            return getValue(keys: Array(keys[1..<keys.count]), array: newArray)
                        }
                    }
                }
                else {
                    return dictionary[currentKey]
                }
            }
            else {
                let keyName = (currentKey as NSString).substring(with: result.range(at: 2))
                let keyValue = (currentKey as NSString).substring(with: result.range(at: 3))
                let valueKey = (currentKey as NSString).substring(with: result.range(at: 4))
                currentKey = (currentKey as NSString).substring(with: result.range(at: 1))
                
                guard let arrayOfPairs = dictionary[currentKey] as? [[String: AnyObject]] else {
                    return nil
                }
                
                for pair in arrayOfPairs {
                    guard let testKeyValue = pair[keyName] as? String, testKeyValue == keyValue else {
                        continue
                    }
                    
                    if let newDictionary = pair[valueKey] as? [String: AnyObject] {
                        return getValue(keys: Array(keys[1..<keys.count]), dictionary: newDictionary)
                    }
                    else {
                        if let newArray = pair[valueKey] as? [AnyObject] {
                            if keys[1] == "[*]" {
                                var values: [AnyObject] = []
                                for value in newArray {
                                    guard let dictionary = getValue(keys: Array(keys[2..<keys.count]), dictionary: value as! [String : AnyObject]) else {
                                        continue
                                    }
                                    values.append(dictionary)
                                }
                                return values as NSArray
                            }
                            return getValue(keys: Array(keys[1..<keys.count]), array: newArray)
                        }
                        else {
                            return pair[valueKey]
                        }
                    }
                }
            }
        }
        catch _ {
            fatalError("This should never happen!")
        }
        
        return nil
    }
    
    public subscript(key: String) -> AnyObject? {
        if key == NKJSON.rootKey {
            return resultDictionary as NSDictionary
        }
        
        let finalKey = (key as String).replacingOccurrences(of: "\\.", with: dotReplacement)
        return getValue(keys: finalKey.components(separatedBy: "."), dictionary: resultDictionary)
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
        guard let float = toFloat(object: object) else {
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
            
            return CGSize(width: CGFloat(width.floatValue), height: CGFloat(height.floatValue))
        }
        
        guard let width = dictionary["width"] else {
            return nil
        }
        
        guard let height = dictionary["height"] else {
            return nil
        }
        
        return CGSize(width: width, height: height)
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
            
            return CGPoint(x: CGFloat(x.floatValue), y: CGFloat(y.floatValue))
        }
        
        guard let x = dictionary["x"] else {
            return nil
        }
        
        guard let y = dictionary["y"] else {
            return nil
        }
        
        return CGPoint(x: x, y: y)
    }
    
    public class func toDate(object: AnyObject?) -> Date? {
        guard let dateString = object as? String else {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "CET")!
        dateFormatter.dateFormat = dateFormat
        
        guard let date = dateFormatter.date(from: dateString) else {
            return dateString.detectDates()?.first
        }
        
        return date
    }
    
    public class func toNilIfEmpty(object: AnyObject?) -> String? {
        guard let string = (object as? String)?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) else {
            return nil
        }
        return string.isEmpty ? nil : string
    }
    
}

public protocol NKJSONParsable {
    
    init?(JSON: NKJSON)
    
}

extension String {
    
    func detectDates() -> [Date]? {
        do {
            return try NSDataDetector(types: NSTextCheckingResult.CheckingType.date.rawValue)
                .matches(in: self, options: [], range: NSRange(0..<count))
                .filter{$0.resultType == .date}
                .flatMap{$0.date}
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
    
}
