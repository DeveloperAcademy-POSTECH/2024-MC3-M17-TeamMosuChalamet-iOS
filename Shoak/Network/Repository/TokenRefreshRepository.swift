//
//  TokenRefreshRepository.swift
//  Shoak
//
//  Created by 정종인 on 8/6/24.
//

import Foundation
import Moya

final class TokenRefreshRepository {
    private let tokenManager = TokenManager.shared
    let provider: MoyaProvider<TokenRefreshAPI>

    init() {
        provider = MoyaProvider<TokenRefreshAPI>(plugins: [
            AddTokenPlugin(tokenManager: tokenManager),
            LoggerPlugin(),
            NetworkLoggerPlugin()
        ])
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
