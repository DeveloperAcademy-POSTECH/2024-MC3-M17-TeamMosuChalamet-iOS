//
//  InvitationAPI.swift
//  Shoak
//
//  Created by 정종인 on 8/5/24.
//

import Foundation
import Moya

enum InvitationAPI {
    case acceptInvitation(TMMemberIDDTO)
}

extension InvitationAPI: NeedAccessTokenTargetType {
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

    var contentType: ContentType {
        switch self {
        case .acceptInvitation(let tMMemberID):
            return .json
        }
    }

    var task: Task {
        switch self {
        case .acceptInvitation(let tmMemberIDDTO):
            return .requestJSONEncodable(tmMemberIDDTO)
        }
    }
}
