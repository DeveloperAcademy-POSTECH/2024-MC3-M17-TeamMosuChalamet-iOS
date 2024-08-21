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
    case deleteFriend(memberID: TMMemberIDDTO)
    case signOut
    case changeName(name: TMNameDTO)
}

extension UserAPI: NeedAccessTokenTargetType {
    var baseURL: URL {
        ShoakURLProvider().provide(version: .none)
    }

    var path: String {
        switch self {
        case .getProfile:
            "/api/profile"
        case .uploadProfileImage:
            "/api/profile/image"
        case .changeName:
            "/api/profile/name"
        case .getFriends, .deleteFriend:
            "/api/friend"
        case .signOut:
            "/api/member"
        }
    }

    var contentType: ContentType {
        switch self {
        case .getProfile, .getFriends, .deleteFriend, .changeName:
            .json
        case .uploadProfileImage:
            .formData
        case .signOut:
            .none
        }
    }

    var method: Moya.Method {
        switch self {
        case .getProfile, .getFriends:
            return .get
        case .uploadProfileImage, .changeName:
            return .patch
        case .deleteFriend:
            return .delete
        case .signOut:
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
                        "name": "여덟글자꽉채워서",
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
        case .deleteFriend, .signOut, .changeName:
            return Data("".utf8)
        }
    }

    var task: Task {
        switch self {
        case .getProfile, .getFriends, .signOut:
            return .requestPlain
        case let .uploadProfileImage(data):
            let jpegData = MultipartFormData(provider: .data(data), name: "profileImage", fileName: "example.jpeg", mimeType: "image/jpeg")

            let multipartData: [MultipartFormData] = [jpegData]

            return .uploadMultipart(multipartData)
        case .deleteFriend(let tmMemberIDDTO):
            return .requestJSONEncodable(tmMemberIDDTO)
        case .changeName(let tmNameDTO):
            return .requestJSONEncodable(tmNameDTO)
        }
    }
}
