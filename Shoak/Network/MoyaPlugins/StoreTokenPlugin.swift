//
//  StoreTokenPlugin.swift
//  Shoak
//
//  Created by 정종인 on 7/29/24.
//

import Moya

/// 받은 헤더에 access token과 refresh token을 인식해서 디바이스 키체인에 저장한다.
struct StoreTokenPlugin: PluginType {
    private let tokenManager: TokenManager
    init(tokenManager: TokenManager) {
        self.tokenManager = tokenManager
    }
    func didReceive(_ result: Result<Response, MoyaError>, target: any TargetType) {
        print("\n🐈🐈🐈🐈 Moya Store Token Plugin 🐈🐈🐈🐈")
        guard case .success(let response) = result else {
            print("❌❌❌❌ response failed. Did nothing.")
            return
        }

        if let accessTokenString = response.response?.allHeaderFields["Access"] as? String {
            let accessToken = AccessToken(accessTokenString)
            print("🐈🐈🐈🐈 try to store accessToken : \(accessToken.token)")
            tokenManager.save(accessToken)
        } else {
            print("❌❌❌❌ No Access Token")
        }

        if let refreshTokenString = response.response?.allHeaderFields["Refresh"] as? String {
            let refreshToken = RefreshToken(refreshTokenString)
            print("🐈🐈🐈🐈 try to store refreshToken : \(refreshToken.token)")
            tokenManager.save(refreshToken)
        } else {
            print("❌❌❌❌ No Refresh Token")
        }
    }
}
