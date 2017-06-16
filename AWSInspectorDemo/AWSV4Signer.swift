//
//  SigningUtil.swift
//  AWSInspectorDemo
//
//  Created by Nikola Lukic on 6/15/17.
//  Copyright © 2017 Nikola Lukic. All rights reserved.
//

import Foundation
import Alamofire


class AWSV4Signer {
    let accessKey = AwsCredentials.AWS_KEY
    let secretKey = AwsCredentials.AWS_SECRET_KEY
    let regionName = AwsUtil.region
    let serviceName = AwsUtil.service

    init() {}

    func signedHeaders(url: NSURL, request: AwsRequest, bodyDigest: String, httpMethod: String = "POST", date: DateTuple) -> [String: String] {
        var headers = [
                "X-Amz-Target": "InspectorService.\(request.rawValue)",
                "x-amz-content-sha256": bodyDigest,
                "X-Amz-Date": date.amazonTimestamp,
                "Content-Type": AwsUtil.contentType,
                "Host": url.host!,
        ]
        headers["Authorization"] = authorization(url: url, headers: headers, datetime: date, httpMethod: httpMethod, bodyDigest: bodyDigest)

        return headers
    }

    // MARK: Utilities

    private func pathForURL(url: NSURL) -> String {
        var path = url.path
        if (path ?? "").isEmpty {
            path = "/"
        }
        return path!
    }

    private func hexdigest(data: Data) -> String {
        var hex = String()
        _ = data.withUnsafeBytes { (pointer: UnsafePointer<UInt8>) in
            for i in 0..<data.count {
                hex += String(format: "%02x", pointer[i])
            }
        }

        return hex
    }

    // MARK: Methods Ported from AWS SDK

    private func authorization(url: NSURL, headers: Dictionary<String, String>, datetime: DateTuple, httpMethod: String, bodyDigest: String) -> String {
        let cred = credential(datetime: datetime)
        let shead = signedHeaders(headers: headers)
        let sig = signature(url: url, headers: headers, datetime: datetime, httpMethod: httpMethod, bodyDigest: bodyDigest)

        return [
                "AWS4-HMAC-SHA256 Credential=\(cred)",
                "SignedHeaders=\(shead)",
                "Signature=\(sig)",
        ].joined(separator: ", ")
    }

    private func credential(datetime: DateTuple) -> String {
        return "\(accessKey)/\(credentialScope(datetime: datetime))"
    }

    func sha256(str: String) -> String {
        let data = str.data(using: .utf8)!
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        _ = data.withUnsafeBytes { (pointer: UnsafePointer<UInt8>) in
            CC_SHA256(pointer, CC_LONG(data.count), &hash)
        }

        let res = NSData(bytes: hash, length: Int(CC_SHA256_DIGEST_LENGTH)) as Data
        return hexdigest(data: res)
    }

    private func hmac(string: String, key: NSData) -> NSData {
        let data = string.cString(using: .utf8)
        let dataLen = Int(string.lengthOfBytes(using: .utf8))
        let digestLen = Int(CC_SHA256_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), key.bytes, key.length, data, dataLen, result);
        return NSData(bytes: result, length: digestLen)
    }

    private func signedHeaders(headers: [String: String]) -> String {
        var list = Array(headers.keys).map {
            $0.lowercased()
        }.sorted()
        if let itemIndex = list.index(of: "authorization") {
            list.remove(at: itemIndex)
        }
        return list.joined(separator: ";")
    }

    private func canonicalHeaders(headers: [String: String]) -> String {
        var list = [String]()
        let keys = Array(headers.keys).sorted {
            $0.localizedCompare($1) == .orderedAscending
        }

        for key in keys {
            if key.caseInsensitiveCompare("authorization") != .orderedSame {
                list.append("\(key.lowercased()):\(headers[key]!)")
            }
        }
        return list.joined(separator: "\n")
    }

    private func signature(url: NSURL, headers: [String: String], datetime: DateTuple, httpMethod: String, bodyDigest: String) -> String {
        let secret = String(format: "AWS4%@", secretKey).data(using: .utf8)! as NSData
        let date = hmac(string: datetime.clientDate, key: secret)
        let region = hmac(string: regionName, key: date)
        let service = hmac(string: serviceName, key: region)
        let credentials = hmac(string: AwsUtil.requestType, key: service)
        let string = stringToSign(datetime: datetime, url: url, headers: headers, httpMethod: httpMethod, bodyDigest: bodyDigest)
        let sig = hmac(string: string, key: credentials)
        return hexdigest(data: sig as Data)
    }

    private func credentialScope(datetime: DateTuple) -> String {
        return [
                datetime.clientDate,
                regionName,
                serviceName,
                AwsUtil.requestType
        ].joined(separator: "/")
    }

    private func stringToSign(datetime: DateTuple, url: NSURL, headers: [String: String], httpMethod: String, bodyDigest: String) -> String {
        return [
                "AWS4-HMAC-SHA256",
                datetime.amazonTimestamp,
                credentialScope(datetime: datetime),
                sha256(str: canonicalRequest(url: url, headers: headers, httpMethod: httpMethod, bodyDigest: bodyDigest)),
        ].joined(separator: "\n")
    }

    private func canonicalRequest(url: NSURL, headers: [String: String], httpMethod: String, bodyDigest: String) -> String {
        return [
                httpMethod,
                pathForURL(url: url),
                url.query ?? "",
                "\(canonicalHeaders(headers: headers))\n",
                signedHeaders(headers: headers),
                bodyDigest,
        ].joined(separator: "\n")
    }
}


extension String: ParameterEncoding {

    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}

