//
//  TokenRefreshAPI.swift
//  Shoak
//
//  Created by 정종인 on 7/29/24.
//

import Foundation
import Moya

enum TokenRefreshAPI {
    case refresh(TMTokenRefreshRequestDTO)
}

extension TokenRefreshAPI: TargetType {
    var baseURL: URL {
        ShoakURLProvider().provide(version: .none)
    }

    var path: String {
        switch self {
        case .refresh:
            "/api/reissue"
        }
    }

    var method: Moya.Method {
        switch self {
        case .refresh:
            .post
        }
    }

    var headers: [String : String]? {
        let headers = [
            "Content-Type": "application/json",
            "Access": "",
            "Refresh": ""
        ]

        return headers
    }

    var task: Task {
        switch self {
        case .refresh(let dto):
            return .requestJSONEncodable(dto)
        }
    }
}
