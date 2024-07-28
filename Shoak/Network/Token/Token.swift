//
//  Token.swift
//  Shoak
//
//  Created by 정종인 on 7/28/24.
//

import Foundation

protocol Token: Codable {
    var token: String { get }
    /// 1970년 1월 1일부터 현재까지 초단위로 센 값
    var expiredTime: TimeInterval { get }
}

extension Token {
    /// 1970년 1월 1일부터 현재까지 초단위로 센 값
    var now: TimeInterval {
        Date().timeIntervalSince1970
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

public struct TokenPair: Codable {
    let accessToken: AccessToken
    let refreshToken: RefreshToken
}
