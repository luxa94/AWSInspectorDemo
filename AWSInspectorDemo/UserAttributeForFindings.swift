//
//  UserAttributeForFindings.swift
//  AWSInspectorDemo
//
//  Created by Nikola Lukic on 6/18/17.
//  Copyright © 2017 Nikola Lukic. All rights reserved.
//

import Foundation

struct UserAttributeForFindings {
    let key: String
    let value: String

    init(key: String, value: String) {
        self.key = key
        self.value = value
    }
}

extension UserAttributeForFindings: JSONConvertible {
    static func fromJSONDictionary(_ json: [String : AnyObject]) -> UserAttributeForFindings? {
        guard let key = json["key"] as? String,
            let value = json["value"] as? String else {
                print("Unable to get UserAttributeForFindings from \(json)")
                return nil
        }
        return UserAttributeForFindings(key: key, value: value)
    }

}
