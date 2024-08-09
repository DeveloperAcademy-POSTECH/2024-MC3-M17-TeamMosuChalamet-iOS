//
//  Token.swift
//  Shoak
//
//  Created by 정종인 on 7/28/24.
//

import Foundation

protocol Token: Codable, Sendable {
    var token: String { get }
}

public struct AccessToken: Token {
    let token: String

    public init(_ token: String) {
        self.token = token
    }
}

public struct RefreshToken: Token {
    let token: String

    public init(_ token: String) {
        self.token = token
    }
}

public struct IdentityToken: Token {
    let token: String

    public init(_ token: String) {
        self.token = token
    }
}

public struct DeviceToken: Token {
    let token: String

    public init(_ token: String) {
        self.token = token
    }
}

public struct AuthCode: Token {
    let token: String

    public init(_ token: String) {
        self.token = token
    }
}
