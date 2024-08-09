//
//  ShoakAPI.swift
//  Shoak
//
//  Created by 정종인 on 7/31/24.
//

import Foundation
import Moya

enum ShoakAPI {
    case shoak(TMMemberIDDTO)
}

extension ShoakAPI: NeedAccessTokenTargetType {
    var baseURL: URL {
        ShoakURLProvider().provide(version: .none)
    }

    var path: String {
        switch self {
        case .shoak:
            "/api/message"
        }
    }

    var method: Moya.Method {
        switch self {
        case .shoak:
            return .post
        }
    }

    var contentType: ContentType {
        .json
    }

    var task: Task {
        switch self {
        case .shoak(let tmMemberIDDTO):
            return .requestJSONEncodable(tmMemberIDDTO)
        }
    }
}
