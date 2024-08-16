//
//  TokenRefreshRepository.swift
//  Shoak
//
//  Created by 정종인 on 8/6/24.
//

import Foundation
import Moya

public protocol TokenRefreshRepository {
    func registerDeviceToken(_ deviceToken: TMDeviceTokenDTO) async -> Result<Void, NetworkError>
    func refreshAccessAndRefreshToken(_ accessToken: String, refreshToken: String) async -> Result<Void, NetworkError>
}

final class DefaultTokenRefreshRepository: TokenRefreshRepository {
    let provider: MoyaProvider<TokenRefreshAPI>

    init(tokenRepository: TokenRepository) {
        provider = MoyaProvider<TokenRefreshAPI>(plugins: [
            AddTokenPlugin(tokenRepository: tokenRepository),
            StoreTokenPlugin(tokenRepository: tokenRepository),
            LoggerPlugin(),
            NetworkLoggerPlugin()
        ])
    }

    func refreshAccessAndRefreshToken(_ accessToken: String, refreshToken: String) async -> Result<Void, NetworkError> {
        let response = await provider.request(.refresh)
        switch response {
        case .success(let success):
            return NetworkHandler.requestPlain(by: success)
        case .failure(let failure):
            return .failure(.other(failure.localizedDescription))
        }
    }

    func registerDeviceToken(_ deviceToken: TMDeviceTokenDTO) async -> Result<Void, NetworkError> {
        let response = await provider.request(.registerDeviceToken(deviceToken))
        switch response {
        case .success(let success):
            return NetworkHandler.requestPlain(by: success)
        case .failure(let failure):
            return .failure(.other(failure.localizedDescription))
        }
    }

}
