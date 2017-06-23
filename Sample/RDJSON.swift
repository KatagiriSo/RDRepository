//
//  RDJSON.swift
//  RDRepository
//
//  Created by 片桐奏羽 on 2017/06/23.
//  Copyright © 2017年 rodhos. All rights reserved.
//

import Foundation

import Foundation

public enum JSONValue  {
    case Object([String:JSONValue])
    case Array([JSONValue])
    case String(String)
    case Number(NSNumber)
    case Null
    public static func wrap(json:Any) -> JSONValue {
        if let dict = json as? [String:Any] {
            var d:[String:JSONValue] = [:]
            for (key, value) in dict { d[key] = wrap(json: value) }
            return .Object(d)
        }
        
        if let array:[Any] = json as? [Any] {
            return .Array(array.map({wrap(json: $0)}
            ))
        }
        
        if let string:String = json as? String {
            return .String(string)
        }
        
        if let num:NSNumber = json as? NSNumber {
            return .Number(num)
        }
        
        return .Null
    }
    
    public static func parse(data: Data) -> JSONValue? {
        if let json: Any = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
            return wrap(json: json)
        } else {
            return nil
        }
    }
    
    public func raw()->Any {
        switch self {
        case .Object(let dic):
            var retDic:[String:Any] = [:]
            for (key, value) in dic {
                retDic[key] = value.raw()
            }
            return retDic
        case .Array(let list):
            var retList:[Any] = []
            for ob in list {
                retList.append(ob.raw())
            }
            return retList
        case .Number(let n):
            return n
        case .String(let s):
            return s;
        case .Null:
            return NSNull()
        }
    }
    
    public var string:String? {
        if case .String(let s) = self {
            return s
        } else {
            return nil
        }
    }
    
    public var number:NSNumber? {
        if case .Number(let n) = self {
            return n
        } else {
            return nil
        }
    }
    
    public var isNull:Bool? {
        if case .Null = self {
            return true
        } else {
            return false
        }
    }
    
    public var dictionary: [String:JSONValue]? {
        if case .Object(let o) = self {
            return o
        } else {
            return nil
        }
    }
    
    public var array : [JSONValue]? {
        if case .Array(let a) = self {
            return a
        } else {
            return nil
        }
    }
    
    public subscript(index: String) -> JSONValue? {
        if case .Object(let o) = self , let value: JSONValue = o[index] {
            return value
        } else {
            return nil
        }
    }
    
    public subscript(index: Int) -> JSONValue? {
        if case .Array(let a) = self {
            let value: JSONValue = a[index]
            return value
        }
        return nil
    }
}

public extension JSONValue {
    public var date:Date? {
        if case .String(let s) = self {
            return self.date(from:s)
        }
        return nil
    }
    
    public func date(from:String?)->Date? {
        guard let string : String = from else { return nil}
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/DD HH:mm:ss"
        return dateFormatter.date(from: string)
    }
    
    public func dateString(from:Date?)->String? {
        guard let date : Date = from else { return nil}
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/DD HH:mm:ss"
        return dateFormatter.string(from: date)
    }
}
