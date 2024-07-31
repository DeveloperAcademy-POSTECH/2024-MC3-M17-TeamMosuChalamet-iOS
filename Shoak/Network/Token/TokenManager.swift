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

/// access token, refresh token, identityToken, deviceToken을 관리한다.
final public class TokenManager: @unchecked Sendable {
    @TokenStorage<AccessToken>() private var accessToken
    @TokenStorage<RefreshToken>() private var refreshToken
    @TokenStorage<IdentityToken>() private var identityToken
    @TokenStorage<DeviceToken>() private var deviceToken

    public init() {
        // get할 때 keychain에서 가져오는 로직을 수행 함.
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        // TODO: 위에꺼로 다시 바꾸기
//        self.accessToken = AccessToken("eyJhbGciOiJIUzI1NiJ9.eyJjYXRlZ29yeSI6ImFjY2VzcyIsInVzZXJuYW1lIjoiMTciLCJyb2xlIjoiUk9MRV9VU0VSIiwiaWF0IjoxNzIyNDM0OTUwLCJleHAiOjE3MjUwMjY5NTB9.RmcsCvh39l2aHtNJVATklJYY7fAuyrdBC8FilAHi0DI")
//
//        self.refreshToken = RefreshToken("eyJhbGciOiJIUzI1NiJ9.eyJjYXRlZ29yeSI6InJlZnJlc2giLCJ1c2VybmFtZSI6IkRlZmF1bHQgTmFtZSIsInJvbGUiOiJST0xFX1VTRVIiLCJpYXQiOjE3MjI0MzQ5NTAsImV4cCI6MTcyNzYxODk1MH0.jmWUHPA6tK1IX3TvPIQrYdga_4IulOFDpGGZJJv0OdY")
    }

    /// URLRequest에 대해 토큰이 유효하다면 Access, Refresh 헤더에 Bearer 토큰 붙여주는 로직 (async/await 기반)
    /// 이 함수를 부르기 전에 토큰을 붙이는 것이 필요한지 먼저 검사하십시오.
    /// - Parameter request: 토큰을 추가하고 싶은 요청
    /// - Returns: 토큰이 헤더에 추가된 요청. 실패 시 token이 없다는 에러 리턴
    func validTokenAndAddHeader(request: URLRequest) -> Result<URLRequest, TokenError> {
        // access Token이 있다면 넣어주기
        if let accessToken, let refreshToken {
            return addBearerHeader(request, accessToken: accessToken, refreshToken: refreshToken)
        }

        return .failure(.noTokens)
    }

    private func addBearerHeader(_ request: URLRequest, accessToken: AccessToken, refreshToken: RefreshToken) -> Result<URLRequest, TokenError> {
        var urlRequest = request
        urlRequest.setValue("Bearer " + accessToken.token, forHTTPHeaderField: "Access")
        urlRequest.setValue("Bearer " + refreshToken.token, forHTTPHeaderField: "Refresh")

        return .success(urlRequest)
    }
}

public extension TokenManager {
    func save(_ accessToken: AccessToken) {
        self.accessToken = accessToken
    }

    func save(_ refreshToken: RefreshToken) {
        self.refreshToken = refreshToken
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
