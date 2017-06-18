//
//  JSONUtil.swift
//  AWSInspectorDemo
//
//  Created by Nikola Lukic on 6/17/17.
//  Copyright © 2017 Nikola Lukic. All rights reserved.
//

import Foundation


protocol JSONConvertible {
    associatedtype T
    func toJSONDictionary() -> [String:AnyObject]
    static func fromJSONDictionary(_ json: [String:AnyObject]) -> T?
}


extension JSONConvertible {

    static func parseJSONToArray(_ arrayOfJSONDictionaries: [[String:AnyObject]]) -> [T] {
        return arrayOfJSONDictionaries.flatMap(fromJSONDictionary)
    }

    func convertToJSONData() throws -> Data {
        return try JSONSerialization.data(withJSONObject: self.toJSONDictionary(), options: JSONSerialization.WritingOptions.prettyPrinted)
    }

    func toJSONDictionary() -> [String:AnyObject] {
        return [:]
    }

}
