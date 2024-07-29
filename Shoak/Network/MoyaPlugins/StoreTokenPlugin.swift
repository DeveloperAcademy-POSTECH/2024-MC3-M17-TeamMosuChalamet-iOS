//
//  StoreTokenPlugin.swift
//  Shoak
//
//  Created by 정종인 on 7/29/24.
//

import Moya

struct StoreTokenPlugin: PluginType {
    private let tokenManager: TokenManager
    init(tokenManager: TokenManager) {
        self.tokenManager = tokenManager
    }
    func didReceive(_ result: Result<Response, MoyaError>, target: any TargetType) {
        print("\n🐈🐈🐈🐈 Moya Store Token Plugin 🐈🐈🐈🐈")
        guard case .success(let response) = result else {
            print("🐈🐈🐈🐈 response failed. Did nothing.")
            return
        }

        if let accessTokenString = response.response?.allHeaderFields["Authorization"] as? String {
            let accessToken = AccessToken(token: accessTokenString, expiredIn: 2000000000)
            print("🐈🐈🐈🐈 try to store accessToken : \(accessToken.token)")
            tokenManager.save(accessToken)
        }

        if let refreshTokenString = response.response?.allHeaderFields["Authorization"] as? String {
            let refreshToken = RefreshToken(token: refreshTokenString, expiredIn: 2000000000)
            print("🐈🐈🐈🐈 try to store refreshToken : \(refreshToken.token)")
            tokenManager.save(refreshToken)
        }
    }
}
