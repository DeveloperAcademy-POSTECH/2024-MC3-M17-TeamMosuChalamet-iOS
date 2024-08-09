//
//  TokenUseCase.swift
//  Shoak
//
//  Created by 정종인 on 8/6/24.
//

import Foundation

public final class TokenUseCase {
    let tokenRepository: TokenRepository
    let tokenRefreshRepository: TokenRefreshRepository

    public init(tokenRepository: TokenRepository, tokenRefreshRepository: TokenRefreshRepository) {
        self.tokenRepository = tokenRepository
        self.tokenRefreshRepository = tokenRefreshRepository
    }

    func refreshDeviceToken(deviceToken: String) async -> Result<Void, NetworkError> {
        return await tokenRefreshRepository.registerDeviceToken(TMDeviceTokenDTO(deviceToken: deviceToken))
    }

    func refreshAccessAndRefreshToken() async -> Result<Void, NetworkError> {
        guard let accessTokenString = tokenRepository.getAccessToken()?.token,
              let refreshTokenString = tokenRepository.getRefreshToken()?.token else {
            return .failure(.other("Cannot get accessToken or refreshToken"))
        }
        return await tokenRefreshRepository.refreshAccessAndRefreshToken(accessTokenString, refreshToken: refreshTokenString)
    }

    func save(accessToken: String) {
        let dto = AccessToken(accessToken)
        tokenRepository.save(accessToken: dto)
    }
    func save(refreshToken: String) {
        let dto = RefreshToken(refreshToken)
        tokenRepository.save(refreshToken: dto)
    }
    func save(identityToken: String) {
        let dto = IdentityToken(identityToken)
        tokenRepository.save(identityToken: dto)
    }
    func save(deviceToken: String) {
        let dto = DeviceToken(deviceToken)
        tokenRepository.save(deviceToken: dto)
    }

    func getAccessToken() -> AccessToken? {
        let dto = tokenRepository.getAccessToken()
        return dto
    }
    func getRefreshToken() -> RefreshToken? {
        let dto = tokenRepository.getRefreshToken()
        return dto
    }
    func getIdentityToken() -> IdentityToken? {
        let dto = tokenRepository.getIdentityToken()
        return dto
    }
    func getDeviceToken() -> DeviceToken? {
        let dto = tokenRepository.getDeviceToken()
        return dto
    }

    func deleteAllTokensWithoutDeviceToken() {
        tokenRepository.deleteAllTokensWithoutDeviceToken()
    }

    func deleteAllTokens() {
        tokenRepository.deleteAllTokens()
    }

    func isLoggedIn() -> Bool {
        if self.getIdentityToken() != nil && self.getAccessToken() != nil {
            return true
        } else {
            return false
        }
    }
}
