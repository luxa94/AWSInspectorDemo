//
//  AssessmentRun.swift
//  AWSInspectorDemo
//
//  Created by Nikola Lukic on 6/18/17.
//  Copyright © 2017 Nikola Lukic. All rights reserved.
//

import Foundation

typealias StringInt = (string: String, int: Int)

struct AssessmentRun {
    let arn: String
    let name: String
    let assessmentTemplateArn: String
    let completedAt: Date?
    let createdAt: Date
    let dataCollected: Bool
    let durationInSeconds: Int
    let findingCounts: [StringInt]
    let notifications: [AssessmentRunNotification]
    let rulesPackageArns: [String]
    let startedAt: Date?
    let state: String
    let stateChangedAt: Date
    let userAttributesForFindings: [UserAttributeForFindings]
}

extension AssessmentRun: JSONConvertible {
    static func fromJSONDictionary(_ json: [String : AnyObject]) -> AssessmentRun? {
        guard let arn = json["arn"] as? String,
            let assessmentTemplateArn = json["assessmentTemplateArn"] as? String,
            let createdAtTimestamp = json["createdAt"] as? Double,
            let dataCollected = json["dataCollected"] as? Bool,
            let durationInSeconds = json["durationInSeconds"] as? Int,
            let findingCountsJSON = json["findingCounts"] as? [String: Int],
            let name = json["name"] as? String,
            let notificationsJSON = json["notifications"] as? [[String: AnyObject]],
            let rulesPackageArns = json["rulesPackageArns"] as? [String],
            let state = json["state"] as? String,
            let userAttributesJSON = json["userAttributesForFindings"] as? [[String: AnyObject]],
            let stateChangedAtTimestamp = json["stateChangedAt"] as? Double
            else {
                return nil
        }

        let createdAt = Date(timeIntervalSince1970: createdAtTimestamp)
        let stateChangedAt = Date(timeIntervalSince1970: stateChangedAtTimestamp)

        let completedAtTimestamp = json["completedAt"] as? Double
        let completedAt = nillableDate(for: completedAtTimestamp)

        let startedAtTimestamp = json["startedAt"] as? Double
        let startedAt = nillableDate(for: startedAtTimestamp)

        let notifications = AssessmentRunNotification.parseJSONToArray(notificationsJSON)
        let userAttributesForFindings = UserAttributeForFindings.parseJSONToArray(userAttributesJSON)

        let findingCounts = findingCountsJSON.flatMap { (param: (key: String, value: Int)) -> StringInt in
            return (string: param.key, int: param.value)
        }

        return AssessmentRun(arn: arn, name: name, assessmentTemplateArn: assessmentTemplateArn, completedAt: completedAt, createdAt: createdAt, dataCollected: dataCollected, durationInSeconds: durationInSeconds, findingCounts: findingCounts, notifications: notifications, rulesPackageArns: rulesPackageArns, startedAt: startedAt, state: state, stateChangedAt: stateChangedAt, userAttributesForFindings: userAttributesForFindings)
    }
}
