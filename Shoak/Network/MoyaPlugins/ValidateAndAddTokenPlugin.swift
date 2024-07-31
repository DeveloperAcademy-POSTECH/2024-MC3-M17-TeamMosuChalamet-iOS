//
//  ValidateAndAddTokenPlugin.swift
//  Shoak
//
//  Created by 정종인 on 7/29/24.
//

import Moya
import Foundation

struct ValidateAndAddTokenPlugin: PluginType {
    private let tokenManager: TokenManager
    init(tokenManager: TokenManager) {
        self.tokenManager = tokenManager
    }
    func prepare(_ request: URLRequest, target: any TargetType) -> URLRequest {
        print("\n🐈🐈🐈🐈 Moya ValidateAndAddTokenPlugin 🐈🐈🐈🐈")
        // 1. 요청에 추가된 Access, Refresh 헤더가 없다면 그냥 넘어간다.
        guard needToken(request) else {
            print("\n🐈🐈🐈🐈 토큰 추가할 필요 없음. Did nothing.")
            return request
        }

        // 2. 헤더에 Access, Refresh이 있다면 그 값을 채워준다.
        let validResult = tokenManager.validTokenAndAddHeader(request: request)
        switch validResult {
        case .success(let success):
            print("\n🐈🐈🐈🐈 헤더에 Token 추가 완료!")
            return success
        case .failure(let failure):
            print("\n❌❌❌❌ 헤더에 Token 추가 실패 : \(failure.localizedDescription)")
            return request
        }
    }

    private func needToken(_ request: URLRequest) -> Bool {
        (request.allHTTPHeaderFields?.keys.contains("Access") ?? false)
        || (request.allHTTPHeaderFields?.keys.contains("Refresh") ?? false)
    }
}
