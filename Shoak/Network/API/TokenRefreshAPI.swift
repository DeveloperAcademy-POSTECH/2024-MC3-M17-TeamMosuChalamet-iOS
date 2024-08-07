//
//  TokenRefreshAPI.swift
//  Shoak
//
//  Created by 정종인 on 7/29/24.
//

import Foundation
import Moya

enum TokenRefreshAPI {
    case refresh
    case registerDeviceToken(TMDeviceTokenDTO)
}

extension TokenRefreshAPI: TargetType {
    var baseURL: URL {
        ShoakURLProvider().provide(version: .none)
    }

    var path: String {
        switch self {
        case .refresh:
            "/api/reissue"
        case .registerDeviceToken:
            "/api/deviceToken"
        }
    }

    var method: Moya.Method {
        switch self {
        case .refresh:
            .post
        case .registerDeviceToken:
            .patch
        }
    }

    var headers: [String : String]? {
        switch self {
        case .refresh:
            let headers = [
                "Content-Type": "application/json",
                "Access": "",
                "Refresh": ""
            ]

            return headers
        case .registerDeviceToken:
            let headers = [
                "Content-Type": "application/json",
                "Access": ""
            ]

            return headers
        }
    }

    var task: Task {
        switch self {
        case .refresh:
            return .requestPlain
        case .registerDeviceToken(let dto):
            return .requestCustomJSONEncodable(dto, encoder: JSONEncoder())
        }
    }
}
