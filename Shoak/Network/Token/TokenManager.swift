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
    func save(_ accessToken: AccessToken)
    func save(_ refreshToken: RefreshToken)
    func save(_ identityToken: IdentityToken)
    func save(_ deviceToken: DeviceToken)

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

    public init() {
        // get할 때 keychain에서 가져오는 로직을 수행 함.
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}

public extension KeychainTokenRepository {
    func save(_ accessToken: AccessToken) {
        self.accessToken = accessToken
        print("save access Token : \(accessToken.token)")

#if os(iOS)
        let watchConnectivity = WatchConnectivityManager.shared
        watchConnectivity.sendMessage(data: ["Access": accessToken.token as Any, "Refresh": refreshToken?.token as Any])
#endif
    }

    func save(_ refreshToken: RefreshToken) {
        self.refreshToken = refreshToken
        print("save refresh Token : \(refreshToken.token)")
#if os(iOS)
        let watchConnectivity = WatchConnectivityManager.shared
        watchConnectivity.sendMessage(data: ["Access": accessToken?.token as Any, "Refresh": refreshToken.token as Any])
#endif
    }

    func save(_ identityToken: IdentityToken) {
        self.identityToken = identityToken
    }

    func save(_ deviceToken: DeviceToken) {
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
        self.accessToken = nil
        self.refreshToken = nil
        self.identityToken = nil
    }

    func deleteAllTokens() {
        self.accessToken = nil
        self.refreshToken = nil
        self.identityToken = nil
        self.deviceToken = nil
    }
}



/// access token, refresh token, identityToken, deviceToken을 관리한다.
//final public class TokenManager: @unchecked Sendable {
//    @TokenStorage<AccessToken>() private var accessToken
//    @TokenStorage<RefreshToken>() private var refreshToken
//    @TokenStorage<IdentityToken>() private var identityToken
//    @TokenStorage<DeviceToken>() private var deviceToken
//
//    static let shared = TokenManager()
//
//    private init() {
//        // get할 때 keychain에서 가져오는 로직을 수행 함.
//        self.accessToken = accessToken
//        self.refreshToken = refreshToken
//    }
//
//    /// - Parameter request: 토큰을 추가하고 싶은 요청
//    /// - Returns: 토큰이 헤더에 추가된 요청. 실패 시 token이 없다는 에러 리턴
//    public func addHeader(request: URLRequest, onlyAccessToken: Bool = false) -> Result<URLRequest, TokenError> {
//        // access Token이 있다면 넣어주기
//        if let accessToken {
//            return addBearerHeader(request, accessToken: accessToken, refreshToken: onlyAccessToken ? nil : refreshToken)
//        }
//
//        return .failure(.noTokens)
//    }
//
//    private func addBearerHeader(_ request: URLRequest, accessToken: AccessToken, refreshToken: RefreshToken?) -> Result<URLRequest, TokenError> {
//        var urlRequest = request
//        urlRequest.setValue("Bearer " + accessToken.token, forHTTPHeaderField: "Access")
//        if let refreshToken {
//            urlRequest.setValue("Bearer " + refreshToken.token, forHTTPHeaderField: "Refresh")
//        }
//
//        return .success(urlRequest)
//    }
//}
//
//public extension TokenManager {
//    func save(_ accessToken: AccessToken) {
//        self.accessToken = accessToken
//        print("save access Token : \(accessToken.token)")
//
//#if os(iOS)
//        let watchConnectivity = WatchConnectivityManager.shared
//        watchConnectivity.sendMessage(data: ["Access": accessToken.token as Any, "Refresh": refreshToken?.token as Any])
//#endif
//    }
//
//    func save(_ refreshToken: RefreshToken) {
//        self.refreshToken = refreshToken
//        print("save refresh Token : \(refreshToken.token)")
//#if os(iOS)
//        let watchConnectivity = WatchConnectivityManager.shared
//        watchConnectivity.sendMessage(data: ["Access": accessToken?.token as Any, "Refresh": refreshToken.token as Any])
//#endif
//    }
//
//    func save(_ identityToken: IdentityToken) {
//        self.identityToken = identityToken
//    }
//
//    func save(_ deviceToken: DeviceToken) {
//        if self.deviceToken?.token != deviceToken.token {
//            Task {
//                if case .success = await self.tokenRefreshRepository?.registerDeviceToken(TMDeviceTokenDTO(deviceToken: deviceToken.token)) {
//                    self.deviceToken = deviceToken
//                }
//            }
//        } else {
//            print("갱신 안됨.")
//        }
//    }
//
//    func getAccessToken() -> AccessToken? {
//        self.accessToken
//    }
//
//    func getRefreshToken() -> RefreshToken? {
//        self.refreshToken
//    }
//
//    func getIdentityToken() -> IdentityToken? {
//        self.identityToken
//    }
//
//    func getDeviceToken() -> DeviceToken? {
//        self.deviceToken
//    }
//
//    func deleteAllTokensWithoutDeviceToken() {
//        self.accessToken = nil
//        self.refreshToken = nil
//        self.identityToken = nil
//    }
//
//    func deleteAllTokens() {
//        self.accessToken = nil
//        self.refreshToken = nil
//        self.identityToken = nil
//        self.deviceToken = nil
//    }
//}
