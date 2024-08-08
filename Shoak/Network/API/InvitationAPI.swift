//
//  InvitationAPI.swift
//  Shoak
//
//  Created by 정종인 on 8/5/24.
//

import Foundation
import Moya

enum InvitationAPI {
    case acceptInvitation(TMMemberID)
}

extension InvitationAPI: TargetType {
    var baseURL: URL {
        ShoakURLProvider().provide(version: .none)
    }

    var path: String {
        switch self {
        case .acceptInvitation:
            "api/friend"
        }
    }

    var method: Moya.Method {
        switch self {
        case .acceptInvitation:
            .post
        }
    }

    var headers: [String : String]? {
        [
            "Access": ""
        ]
    }

    var task: Task {
        switch self {
        case .acceptInvitation(let tmMemberID):
            return .requestJSONEncodable(AcceptInvitationDTO(id: tmMemberID))
        }
    }
}
