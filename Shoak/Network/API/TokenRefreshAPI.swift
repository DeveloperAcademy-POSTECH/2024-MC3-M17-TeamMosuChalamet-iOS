//
//  TokenRefreshAPI.swift
//  Shoak
//
//  Created by 정종인 on 7/29/24.
//

import Foundation
import Moya

enum TokenRefreshAPI {
    case refresh(RefreshToken)
}

extension TokenRefreshAPI: TargetType {
    var baseURL: URL {
        ShoakURLProvider().provide(version: .none)
    }

    var path: String {
        switch self {
        case .refresh(let refreshToken):
            "" // TODO: refresh api path 넣기
        }
    }

    var method: Moya.Method {
        switch self {
        case .refresh(let refreshToken):
            .post // TODO: refresh api method 넣기
        }
    }

    var headers: [String : String]? {
        var headers = ["Content-Type": "application/json"]

        return headers
    }

    var sampleData: Data {
        switch self {
        case .refresh(let refreshToken):
            return Data(
                """
                {
                    "accessToken": {
                        "token": "accessaccessaccessaccess",
                        "expiredTime": 2000000000
                    },
                    "refreshToken": {
                        "token": "refreshrefreshrefreshrefresh",
                        "expiredTime": 2000000000
                    }
                }
                """.utf8 // TODO: 샘플데이터 손보기
            )
        }
    }

    var task: Task {
        switch self {
        case .refresh(let refreshToken):
            let parameters = ["refreshToken": refreshToken.token]
            // TODO: 파라미터 확인
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
}
