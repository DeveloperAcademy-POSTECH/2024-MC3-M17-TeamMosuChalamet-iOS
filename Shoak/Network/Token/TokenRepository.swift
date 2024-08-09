//
//  TokenManager.swift
//  Shoak
//
//  Created by 정종인 on 7/28/24.
//

import Foundation

public enum TokenError: Error {
    case noTokens
    case cannotRefresh
}

/// TokenRepository : 토큰을 저장하거나 접근하는 저장소
public protocol TokenRepository {
    func save(accessToken: AccessToken?)
    func save(refreshToken: RefreshToken?)
    func save(identityToken: IdentityToken?)
    func save(deviceToken: DeviceToken?)

    func getAccessToken() -> AccessToken?
    func getRefreshToken() -> RefreshToken?
    func getIdentityToken() -> IdentityToken?
    func getDeviceToken() -> DeviceToken?
    func deleteAllTokensWithoutDeviceToken()
    func deleteAllTokens()
}

final public class KeychainTokenRepository: TokenRepository, @unchecked Sendable {
    @TokenStorage<AccessToken>() private var accessToken
    @TokenStorage<RefreshToken>() private var refreshToken
    @TokenStorage<IdentityToken>() private var identityToken
    @TokenStorage<DeviceToken>() private var deviceToken

    public init() {}
}

public extension KeychainTokenRepository {
    func save(accessToken: AccessToken?) {
        self.accessToken = accessToken
        print("save access Token : \(String(describing: accessToken?.token))")

#if os(iOS) && !APPCLIP
        let watchConnectivity = WatchConnectivityManager.shared
        watchConnectivity.sendMessage(data: ["Access": accessToken?.token as Any, "Refresh": refreshToken?.token as Any])
#endif
    }

    func save(refreshToken: RefreshToken?) {
        self.refreshToken = refreshToken
        print("save refresh Token : \(String(describing: refreshToken?.token))")
#if os(iOS) && !APPCLIP
        let watchConnectivity = WatchConnectivityManager.shared
        watchConnectivity.sendMessage(data: ["Access": accessToken?.token as Any, "Refresh": refreshToken?.token as Any])
#endif
    }

    func save(identityToken: IdentityToken?) {
        self.identityToken = identityToken
    }

    func save(deviceToken: DeviceToken?) {
        self.deviceToken = deviceToken
    }

    func getAccessToken() -> AccessToken? {
        self.accessToken
    }

    func getRefreshToken() -> RefreshToken? {
        self.refreshToken
    }

    func getIdentityToken() -> IdentityToken? {
        self.identityToken
    }

    func getDeviceToken() -> DeviceToken? {
        self.deviceToken
    }

    func deleteAllTokensWithoutDeviceToken() {
        self.save(accessToken: nil)
        self.save(refreshToken: nil)
        self.save(identityToken: nil)
    }

    func deleteAllTokens() {
        self.save(accessToken: nil)
        self.save(refreshToken: nil)
        self.save(identityToken: nil)
        self.save(deviceToken: nil)
    }
}
