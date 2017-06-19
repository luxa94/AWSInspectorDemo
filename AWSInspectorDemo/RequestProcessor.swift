//
// Created by Nikola Lukic on 6/16/17.
// Copyright (c) 2017 Nikola Lukic. All rights reserved.
//

import Foundation
import Alamofire

enum AwsRequest: String {
    case listAssessmentRuns = "ListAssessmentRuns"
    case listAssessmentTemplates = "ListAssessmentTemplates"
    case describeAssessmentRuns = "DescribeAssessmentRuns"
    case describeAssessmentTemplates = "DescribeAssessmentTemplates"
    case startAssessmentRun = "StartAssessmentRun"


    func method() -> HTTPMethod {
        switch self {
        case .listAssessmentRuns: return .post
        case .listAssessmentTemplates: return .post
        case .describeAssessmentRuns: return .post
        case .describeAssessmentTemplates: return .post
        case .startAssessmentRun: return .post
        }
    }
}

class RequestProcessor {

    let dateFormat: DateFormat
    let signer: AWSV4Signer

    init() {
        dateFormat = DateFormat()
        signer = AWSV4Signer()
    }

    func sendRequest(request: AwsRequest, parameters: Any = [:]) -> DataRequest {
        let date = dateFormat.formattedTime()
        let canonicalQueryString = "Action=InspectorService.\(request.rawValue)&Version=2016-06-06"
        let urlString = "\(AwsUtil.endpoint)?\(canonicalQueryString)"
        let url = NSURL(string: urlString)!
        let bodyString = JSONString(parameters: parameters)
        let bodyDigest = signer.sha256(str: bodyString)
        let headers = signer.signedHeaders(url: url, request: request, bodyDigest: bodyDigest, httpMethod: request.method().rawValue, date: date)

        return Alamofire.request(urlString, method: request.method(), encoding: bodyString, headers: headers)
    }

    private func JSONString(parameters: Any) -> String {
        if let json = try? JSONSerialization.data(withJSONObject: parameters), let string = String(data: json, encoding: .utf8) {
            return string
        }
        return ""
    }

}
