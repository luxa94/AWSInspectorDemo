//
//  AssessmentRunNotification.swift
//  AWSInspectorDemo
//
//  Created by Nikola Lukic on 6/18/17.
//  Copyright © 2017 Nikola Lukic. All rights reserved.
//

import Foundation

struct AssessmentRunNotification {
    let date: Date
    let error: Bool
    let event: String
    let message: String?
    let snsTopicArn: String?
}

extension AssessmentRunNotification: JSONConvertible {
    static func fromJSONDictionary(_ json: [String : AnyObject]) -> AssessmentRunNotification? {
        guard let timestamp = json["date"] as? Double,
            let error = json["error"] as? Bool,
            let event  = json["event"] as? String
            else {
                return nil
        }

        let date = Date(timeIntervalSince1970: timestamp)
        let message = json["message"] as? String
        let snsTopicArn = json["snsTopicArn"] as? String

        return AssessmentRunNotification(date: date, error: error, event: event, message: message, snsTopicArn: snsTopicArn)
    }
}
