//
//  TargetType+.swift
//  Shoak
//
//  Created by 정종인 on 7/27/24.
//

import Foundation
import Moya

public protocol NeedAccessTokenTargetType: TargetType {
    var contentType: ContentType { get }
}

extension NeedAccessTokenTargetType {
    public var headers: [String : String]? {
        var headers = contentType.header

        headers["Access"] = ""

        return headers
    }
}

public enum ContentType {
    case json
    case formData
    case none

    var header: [String: String] {
        switch self {
        case .json:
            ["Content-Type": "application/json"]
        case .formData:
            ["Content-Type": "multipart/form-data"]
        case .none:
            [:]
        }
    }
}

public extension TargetType {
    var validationType: ValidationType { .successAndRedirectCodes }
}
