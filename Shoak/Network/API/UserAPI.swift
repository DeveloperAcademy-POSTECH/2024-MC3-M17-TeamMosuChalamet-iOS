//
//  UserAPI.swift
//  Shoak
//
//  Created by 정종인 on 7/27/24.
//

import Foundation
import Moya

enum UserAPI {
    case getProfile
    case getFriends
}

extension UserAPI: NeedAuthTargetType {
    var baseURL: URL {
        ShoakURLProvider().provide(version: .none)
    }

    var path: String {
        switch self {
        case .getProfile:
            "/api/profile"
        case .getFriends:
            "/api/friend"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getProfile, .getFriends:
            return .get
        }
    }

    var sampleData: Data {
        switch self {
        case .getProfile:
            return Data(
                """
                {
                    "name": "이빈치",
                    "imageURL": "https://ada-mc3.s3.ap-northeast-2.amazonaws.com/profile/a7b899ae-528e-4e37-a6f1-e9ac08ab50c9vinci.jpeg"
                }
                """.utf8
            )
        case .getFriends:
            return Data(
                """
                [
                    {
                        "id": 2,
                        "name": "백쿠미Test",
                        "imageURL": "https://ada-mc3.s3.ap-northeast-2.amazonaws.com/profile/kumi.jpeg"
                    },
                    {
                        "id": 3,
                        "name": "정모수Test",
                        "imageURL": "https://ada-mc3.s3.ap-northeast-2.amazonaws.com/profile/mosu.png"
                    }
                ]
                """.utf8
            )
        }
    }

    var task: Task {
        switch self {
        case .getProfile, .getFriends:
            return .requestPlain
        }
    }
}
