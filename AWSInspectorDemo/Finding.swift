//
//  Finding.swift
//  AWSInspectorDemo
//
//  Created by Nikola Lukic on 6/20/17.
//  Copyright © 2017 Nikola Lukic. All rights reserved.
//

import Foundation

struct StringString {
    let key: String
    let value: String
}

extension StringString: JSONConvertible {
    static func fromJSONDictionary(_ json: [String : AnyObject]) -> StringString? {
        guard let key = json["key"] as? String,
            let value = json["value"] as? String
            else {
                print("Unable to parse StringString")
                return nil
        }

        return StringString(key: key, value: value)
    }
}

struct Finding {
    let arn: String
    let assetType: String?
    let attributes: [StringString]
    let confidence: Int?
    let createdAt: Date
    let description: String?
    let id: String?
    let numericSeverity: Double?
    let recommendation: String?
    let schemaVersion: Int?
    let service: String?
    let severity: String?
    let title: String?
    let updatedAt: Date
    let userAttributes: [StringString]
}

extension Finding: JSONConvertible {
    static func fromJSONDictionary(_ json: [String : AnyObject]) -> Finding? {
        guard let arn = json["arn"] as? String,
            let createdAtTimestamp = json["createdAt"] as? Double,
            let attributesJSON = json["attributes"] as? [[String: AnyObject]],
            let updatedAtTimestamp = json["updatedAt"] as? Double,
            let userAttributesJSON = json["attributes"] as? [[String: AnyObject]]
            else {
                print("Unable to deserialize finding.")
                return nil
        }

        let createdAt = Date(timeIntervalSince1970: createdAtTimestamp)
        let updatedAt = Date(timeIntervalSince1970: updatedAtTimestamp)
        let attributes = StringString.parseJSONToArray(attributesJSON)
        let userAttributes = StringString.parseJSONToArray(userAttributesJSON)

        let assetType = json["assetType"] as? String
        let confidence = json["confidence"] as? Int
        let description = json["confidence"] as? String
        let id = json["id"] as? String
        let numericSeverity = json["numericSeverity"] as? Double
        let recommendation = json["recommendation"] as? String
        let schemaVersion = json["schemaVersion"] as? Int
        let service = json["service"] as? String
        let severity = json["severity"] as? String
        let title = json["title"] as? String

        return Finding(arn: arn, assetType: assetType, attributes: attributes, confidence: confidence, createdAt: createdAt, description: description, id: id, numericSeverity: numericSeverity, recommendation: recommendation, schemaVersion: schemaVersion, service: service, severity: severity, title: title, updatedAt: updatedAt, userAttributes: userAttributes)
    }
}
