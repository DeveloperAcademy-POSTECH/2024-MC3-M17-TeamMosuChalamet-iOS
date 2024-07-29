//
//  TokenManager.swift
//  Shoak
//
//  Created by 정종인 on 7/28/24.
//

import Foundation

public enum TokenError: Error {
    case refreshTokenExpired
    case cannotRefreshToken
}

final public class TokenManager {
    @TokenStorage<AccessToken>() private var accessToken
    @TokenStorage<RefreshToken>() private var refreshToken

    private let refreshAPIService: TokenRefreshAPIService

    public init(refreshAPIService: TokenRefreshAPIService) {
        self.refreshAPIService = refreshAPIService
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }

    /// URLRequest에 대해 토큰이 유효하다면 Authorization 헤더에 Bearer 토큰 붙여주는 로직 (async/await 기반)
    /// - Parameter request: 토큰을 추가하고 싶은 요청
    /// - Returns: 토큰이 헤더에 추가된 요청. refresh token 만료 시 토큰에러
    func validTokenAndAddHeader(request: URLRequest) async -> Result<URLRequest, TokenError> {
        // access Token이 있다면 넣어주기
        // (접근할 때 자동으로 만료 체크 함)
        if let accessToken {
            return addBearerHeader(request, with: accessToken)
        }

        // access Token이 만료되었으므로 refreshToken을 활용해서 refresh하기
        // (접근할 때 자동으로 만료 체크 함)
        if let refreshToken {
            let refreshResult = await self.refreshAPIService.refresh(with: refreshToken)
            switch refreshResult {
            case .success(let success):
                self.accessToken = success.accessToken
                self.refreshToken = success.refreshToken
                guard let newAccessToken = self.accessToken else {
                    return .failure(.cannotRefreshToken)
                }
                return self.addBearerHeader(request, with: newAccessToken)
            case .failure(let failure):
                print("refresh failed : \(failure)")
                return .failure(.cannotRefreshToken)
            }
        }

        // refresh token도 만료되었으므로 에러 뱉기.
        return .failure(.refreshTokenExpired)
    }

    private func addBearerHeader(_ request: URLRequest, with accessToken: AccessToken) -> Result<URLRequest, TokenError> {
        var urlRequest = request
        urlRequest.setValue("Bearer " + accessToken.token, forHTTPHeaderField: "Authorization")

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

    func deleteAllTokens() {
        self.accessToken = nil
        self.refreshToken = nil
    }
}
