//
//  TargetType+.swift
//  Shoak
//
//  Created by 정종인 on 7/27/24.
//

import Foundation
import Moya

public protocol NeedAuthTargetType: TargetType {}

extension NeedAuthTargetType {
    public var headers: [String : String]? {
        var headers = ["Content-Type": "application/json"]

//        headers["Authorization"] = ""

        return headers
    }
}
