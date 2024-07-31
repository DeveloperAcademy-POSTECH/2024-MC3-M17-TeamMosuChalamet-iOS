//
//  ShoakAPI.swift
//  Shoak
//
//  Created by 정종인 on 7/31/24.
//

import Foundation
import Moya

enum ShoakAPI {
    case shoak(TMShoakDestinationDTO)
}

extension ShoakAPI: TargetType {
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

    var headers: [String : String]? {
        [
            "Content-Type": "application/json",
            "Access": ""
        ]
    }

    var task: Task {
        switch self {
        case .shoak(let tmShoakDestinationDTO):
            return .requestJSONEncodable(tmShoakDestinationDTO)
        }
    }
}
