//
//  Token.swift
//  Shoak
//
//  Created by 정종인 on 7/28/24.
//

import Foundation

protocol Token: Codable {
    var token: String { get }
    var expiredTime: TimeInterval { get }
}

extension Token {
    var now: TimeInterval {
        Date().timeIntervalSince1970 * 1000
    }

    func isValidate() -> Bool {
        now < expiredTime
    }

    func isExpired() -> Bool {
        !isValidate()
    }
}

public struct AccessToken: Token {
    let token: String
    let expiredTime: TimeInterval

    public init(token: String, expiredIn: Int) {
        self.token = token
        self.expiredTime = TimeInterval(expiredIn)
    }
}

public struct RefreshToken: Token {
    let token: String
    let expiredTime: TimeInterval

    public init(token: String, expiredIn: Int) {
        self.token = token
        self.expiredTime = TimeInterval(expiredIn)
    }
}

