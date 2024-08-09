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
        print("\n🐈🐈🐈🐈 Moya AddTokenPlugin 🐈🐈🐈🐈")

        // 헤더에 Access, Refresh이 있다면 그 값을 채워준다.
        let modifiedRequest = addHeader(request: request)

        return modifiedRequest
    }

    private func addHeader(request: URLRequest) -> URLRequest {
        var request = request

        if needAccessToken(request),
           let accessToken = tokenRepository.getAccessToken() {
            print("\n🐈🐈🐈🐈 헤더에 Access Token 추가 완료!")
            request.setValue("Bearer \(accessToken.token)", forHTTPHeaderField: "Access")
        }

        if needRefreshToken(request),
           let refreshToken = tokenRepository.getRefreshToken() {
            print("\n🐈🐈🐈🐈 헤더에 Refresh Token 추가 완료!")
            request.setValue("Bearer \(refreshToken.token)", forHTTPHeaderField: "Refresh")
        }

        if needIdentityToken(request),
           let identityToken = tokenRepository.getIdentityToken() {
            print("\n🐈🐈🐈🐈 헤더에 Identity Token 추가 완료!")
            request.setValue("Bearer \(identityToken.token)", forHTTPHeaderField: "Identity-Token")
        }

        if needDeviceToken(request),
           let deviceToken = tokenRepository.getDeviceToken() {
            print("\n🐈🐈🐈🐈 헤더에 Device Token 추가 완료!")
            request.setValue("\(deviceToken.token)", forHTTPHeaderField: "Device-Token")
        }

        return request
    }

    private func needAccessToken(_ request: URLRequest) -> Bool {
        request.allHTTPHeaderFields?.keys.contains("Access") ?? false
    }

    private func needRefreshToken(_ request: URLRequest) -> Bool {
        request.allHTTPHeaderFields?.keys.contains("Refresh") ?? false
    }

    private func needIdentityToken(_ request: URLRequest) -> Bool {
        request.allHTTPHeaderFields?.keys.contains("Identity-Token") ?? false
    }

    private func needDeviceToken(_ request: URLRequest) -> Bool {
        request.allHTTPHeaderFields?.keys.contains("Device-Token") ?? false
    }
}
