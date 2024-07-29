//
//  AuthAPI.swift
//  Shoak
//
//  Created by 정종인 on 7/29/24.
//

import Foundation
import Moya

enum AuthAPI {
    case loginOrSignUp(tmLoginOrSignUpDTO: TMLoginOrSignUpDTO)
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        ShoakURLProvider().provide(version: .none)
    }

    var path: String {
        switch self {
        case .loginOrSignUp:
            "/api/signup"
        }
    }

    var method: Moya.Method {
        switch self {
        case .loginOrSignUp:
            return .post
        }
    }

    var sampleData: Data {
        switch self {
        case .loginOrSignUp:
            return Data(
                """
                {
                    "name": "이빈치",
                    "imageURL": "https://ada-mc3.s3.ap-northeast-2.amazonaws.com/profile/a7b899ae-528e-4e37-a6f1-e9ac08ab50c9vinci.jpeg"
                }
                """.utf8
            )
        }
    }

    var headers: [String : String]? {
        ["Content-Type": "application/json"]
    }

    var task: Task {
        switch self {
        case .loginOrSignUp(let tmLoginOrSignUpDTO):
            return .requestJSONEncodable(tmLoginOrSignUpDTO)
        }
    }
}
