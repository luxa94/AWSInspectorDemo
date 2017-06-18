//
//  Arns.swift
//  AWSInspectorDemo
//
//  Created by Nikola Lukic on 6/17/17.
//  Copyright © 2017 Nikola Lukic. All rights reserved.
//

import Foundation

struct Arns {
    let jsonName: String
    let arns: [String]

    init (jsonName: String, arns: [String]) {
        self.jsonName = jsonName
        self.arns = arns
    }
}


extension Arns {

    static func fromJSONDictionary(_ json: [String : AnyObject], jsonName: String) -> Arns? {
        guard let arns = json[jsonName] as? [String] else {
            print("Can't extract arns for \(jsonName) for \(json)")
            return nil
        }

        return Arns(jsonName: jsonName, arns: arns)
    }

    func toJSONDictionary() -> [String : AnyObject] {
        return [jsonName : arns as AnyObject]
    }

}

