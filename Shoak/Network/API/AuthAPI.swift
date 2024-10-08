//
//  AuthAPI.swift
//  Shoak
//
//  Created by 정종인 on 7/29/24.
//

import Foundation
import Moya

enum AuthAPI {
    case loginOrSignUp(credential: TMUserCredentialDTO)
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        ShoakURLProvider().provide(version: .none)
    }

    var path: String {
        switch self {
        case .loginOrSignUp:
            "/login"
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
                "".utf8
            )
        }
    }

    var headers: [String : String]? {
        switch self {
        case .loginOrSignUp(let credential):
            return [
                "Content-Type": "application/json",
                "Identity-Token": "",
                "Device-Token": "",
                "Authorization-Code": "\(credential.authCode)"
            ]
        }
    }

    var task: Task {
        switch self {
        case .loginOrSignUp:
            return .requestPlain
        }
    }
}
