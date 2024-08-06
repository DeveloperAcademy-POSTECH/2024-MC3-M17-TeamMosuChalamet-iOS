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
    case uploadProfileImage(data: Data)
    case deleteFriend(memberID: TMMemberID)
}

extension UserAPI: NeedAccessTokenTargetType {
    var baseURL: URL {
        ShoakURLProvider().provide(version: .none)
    }

    var path: String {
        switch self {
        case .getProfile, .uploadProfileImage:
            "/api/profile"
        case .getFriends, .deleteFriend:
            "/api/friend"
        }
    }

    var contentType: ContentType {
        switch self {
        case .getProfile, .getFriends:
            .json
        case .uploadProfileImage:
            .formData
        case .deleteFriend:
            .none
        }
    }

    var method: Moya.Method {
        switch self {
        case .getProfile, .getFriends:
            return .get
        case .uploadProfileImage:
            return .patch
        case .deleteFriend:
            return .delete
        }
    }

    var sampleData: Data {
        switch self {
        case .getProfile:
            return Data(
                """
                {
                    "id": 1,
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
        case .uploadProfileImage:
            return Data(
                """
                {
                    "name": "이빈치",
                    "imageURL": "https://ada-mc3.s3.ap-northeast-2.amazonaws.com/profile/a7b899ae-528e-4e37-a6f1-e9ac08ab50c9vinci.jpeg"
                }
                """.utf8
            )
        case .deleteFriend:
            return Data("".utf8)
        }
    }

    var task: Task {
        switch self {
        case .getProfile, .getFriends:
            return .requestPlain
        case let .uploadProfileImage(data):
            let jpegData = MultipartFormData(provider: .data(data), name: "profileImage", fileName: "example.jpeg", mimeType: "image/jpeg")

            let multipartData: [MultipartFormData] = [jpegData]

            return .uploadMultipart(multipartData)
        case .deleteFriend(let memberID):
            let queries: [String: Any] = [
                "friendId": memberID
            ]
            return .requestParameters(parameters: queries, encoding: URLEncoding.queryString)
        }
    }
}
