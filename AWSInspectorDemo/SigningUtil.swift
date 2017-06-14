//
//  SigningUtil.swift
//  AWSInspectorDemo
//
//  Created by Nikola Lukic on 6/15/17.
//  Copyright © 2017 Nikola Lukic. All rights reserved.
//

import Foundation

class SigningUtil {

    func sign(key: String, message: String) -> String {
        return message.sha1(key: key)
    }

    func signatureKey(dateStamp: String) -> String {
        let kDate = dateStamp.sha1(key: "AWS4\(AwsCredentials.AWS_SECRET_KEY)")
        let kRegion = AwsUtil.region.sha1(key: kDate)
        let kService = AwsUtil.service.sha1(key: kRegion)
        return "aws4_request".sha1(key: kService)
    }

}


enum CryptoAlgorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512

    var HMACAlgorithm: CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:      result = kCCHmacAlgMD5
        case .SHA1:     result = kCCHmacAlgSHA1
        case .SHA224:   result = kCCHmacAlgSHA224
        case .SHA256:   result = kCCHmacAlgSHA256
        case .SHA384:   result = kCCHmacAlgSHA384
        case .SHA512:   result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }

    var digestLength: Int {
        var result: Int32 = 0
        switch self {
        case .MD5:      result = CC_MD5_DIGEST_LENGTH
        case .SHA1:     result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:   result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:   result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:   result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:   result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}

extension String {

    func sha1(key: String) -> String {
        return hmac(algorithm: .SHA1, key: key)
    }

    func hmac(algorithm: CryptoAlgorithm, key: String) -> String {
        let str = self.cString(using: .utf8)
        let strLen = Int(self.lengthOfBytes(using: .utf8))
        let digestLen = algorithm.digestLength
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        let keyStr = key.cString(using: .utf8)
        let keyLen = Int(key.lengthOfBytes(using: String.Encoding.utf8))

        CCHmac(algorithm.HMACAlgorithm, keyStr!, keyLen, str!, strLen, result)

        let digest = stringFromResult(result: result, length: digestLen)

        result.deallocate(capacity: digestLen)

        return digest
    }

    private func stringFromResult(result: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String {
        let hash = NSMutableString()
        for i in 0..<length {
            hash.appendFormat("%02x", result[i])
        }
        return String(hash)
    }
    
}
