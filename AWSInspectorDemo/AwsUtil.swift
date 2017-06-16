//
//  AwsUtil.swift
//  AWSInspectorDemo
//
//  Created by Nikola Lukic on 6/15/17.
//  Copyright © 2017 Nikola Lukic. All rights reserved.
//

import Foundation

class AwsUtil {
    static let contentType = "application/x-amz-json-1.1"
    static let service = "inspector"
    static let region = "us-west-2"
    static let host = "inspector.us-west-2.amazonaws.com"
    static let endpoint = "https://inspector.us-west-2.amazonaws.com"
    static let url = NSURL(string: AwsUtil.endpoint)!
    static let requestType = "aws4_request"
}
