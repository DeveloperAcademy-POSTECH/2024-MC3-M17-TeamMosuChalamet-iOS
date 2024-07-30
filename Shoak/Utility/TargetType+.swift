//
//  TargetType+.swift
//  Shoak
//
//  Created by 정종인 on 7/27/24.
//

import Foundation
import Moya

public protocol NeedAuthTargetType: TargetType {
    var contentType: ContentType { get }
}

extension NeedAuthTargetType {
    public var headers: [String : String]? {
        var headers = contentType.header

        headers["Authorization"] = ""

        return headers
    }
}

public enum ContentType {
    case json
    case formData

    var header: [String: String] {
        switch self {
        case .json:
            ["Content-Type": "application/json"]
        case .formData:
            ["Content-Type": "multipart/form-data"]
        }
    }
}
