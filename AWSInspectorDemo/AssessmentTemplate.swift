//
//  AssessmentTemplate.swift
//  AWSInspectorDemo
//
//  Created by Nikola Lukic on 6/18/17.
//  Copyright © 2017 Nikola Lukic. All rights reserved.
//

import Foundation

struct AssessmentTemplate {
    let arn: String
    let assessmentTargetArn: String
    let createdAt: Date
    let durationInSeconds: Int
    let name: String
    let rulesPackageArns: [String]
    let userAttributesForFindings: [UserAttributeForFindings]

//    init(arn: String, assessmentTargetArn: String, createdAt: Date, durationInSeconds: Int, name: String, rulesPackageArns: [String], userAttributesForFindings: [UserAttributeForFindings]) {
//        self.arn = arn
//        self.assessmentTargetArn = assessmentTargetArn
//        self.createdAt = createdAt
//        self.durationInSeconds = durationInSeconds
//        self.name = name
//        self.rulesPackageArns = rulesPackageArns
//        self.userAttributesForFindings = userAttributesForFindings
//    }
}

extension AssessmentTemplate: JSONConvertible {
    static func fromJSONDictionary(_ json: [String : AnyObject]) -> AssessmentTemplate? {
        guard let arn = json["arn"] as? String,
            let assessmentTargetArn = json["assessmentTargetArn"] as? String,
            let name = json["name"] as? String,
            let timestamp = json["createdAt"] as? Double,
            let durationInSeconds = json["durationInSeconds"] as? Int,
            let rulesPackageArns = json["rulesPackageArns"] as? [String],
            let userAttributes = json["userAttributesForFindings"] as? [[String:AnyObject]] else {
                print("Unable to get AssessmentTemplate from \(json)")
                return nil
        }

        let createdAt = Date(timeIntervalSince1970: timestamp)
        let userAttributesForFindings = UserAttributeForFindings.parseJSONToArray(userAttributes)

        return AssessmentTemplate(arn: arn, assessmentTargetArn: assessmentTargetArn, createdAt: createdAt, durationInSeconds: durationInSeconds, name: name, rulesPackageArns: rulesPackageArns, userAttributesForFindings: userAttributesForFindings)
    }
}
