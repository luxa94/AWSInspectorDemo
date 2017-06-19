//
//  Telemetry.swift
//  AWSInspectorDemo
//
//  Created by Nikola Lukic on 6/19/17.
//  Copyright © 2017 Nikola Lukic. All rights reserved.
//

import Foundation

struct Telemetry {
    let count: Int64
    let dataSize: Int64?
    let messageType: String
}

extension Telemetry: JSONConvertible {
    static func fromJSONDictionary(_ json: [String : AnyObject]) -> Telemetry? {
        guard let count = json["count"] as? Int64,
            let messageType = json["messageType"] as? String
            else {
                return nil
        }

        let dataSize = json["dataSize"] as? Int64
        return Telemetry(count: count, dataSize: dataSize, messageType: messageType)
    }
}
