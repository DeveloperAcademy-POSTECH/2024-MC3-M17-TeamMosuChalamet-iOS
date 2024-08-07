//
//  ValidateAndAddTokenPlugin.swift
//  Shoak
//
//  Created by 정종인 on 7/29/24.
//

import Moya
import Foundation

struct AddTokenPlugin: PluginType {
    private let tokenRepository: TokenRepository
    init(tokenRepository: TokenRepository) {
        self.tokenRepository = tokenRepository
    }
    func prepare(_ request: URLRequest, target: any TargetType) -> URLRequest {
        print("\n🐈🐈🐈🐈 Moya ValidateAndAddTokenPlugin 🐈🐈🐈🐈")

        // 헤더에 Access, Refresh이 있다면 그 값을 채워준다.
        let modifiedRequest = addHeader(request: request)
        print("\n🐈🐈🐈🐈 헤더에 Token 추가 완료!")
        return modifiedRequest
    }

    private func addHeader(request: URLRequest) -> URLRequest {
        var request = request

        if needAccessToken(request),
            let accessToken = tokenRepository.getAccessToken() {
            request.setValue("Bearer \(accessToken.token)", forHTTPHeaderField: "Access")
        }

        if needRefreshToken(request),
           let refreshToken = tokenRepository.getRefreshToken() {
            request.setValue("Bearer \(refreshToken.token)", forHTTPHeaderField: "Refresh")
        }

        return request
    }

    private func needAccessToken(_ request: URLRequest) -> Bool {
        request.allHTTPHeaderFields?.keys.contains("Access") ?? false
    }

    private func needRefreshToken(_ request: URLRequest) -> Bool {
        request.allHTTPHeaderFields?.keys.contains("Refresh") ?? false
    }
}
