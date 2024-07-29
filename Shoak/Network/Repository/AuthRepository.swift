//
//  AuthRepository.swift
//  Shoak
//
//  Created by 정종인 on 7/29/24.
//

import Foundation
import Moya

final class AuthRepository {
    let apiClient: APIClient
    let provider: MoyaProvider<AuthAPI>

    init(apiClient: APIClient) {
        self.apiClient = apiClient
        self.provider = apiClient.resolve(for: AuthAPI.self)
    }

    func loginOrSignUp(loginOrSignUpDTO: TMLoginOrSignUpDTO) async -> Result<TMProfileDTO, NetworkError> {
        let response = await provider.request(.loginOrSignUp(tmLoginOrSignUpDTO: loginOrSignUpDTO))
        switch response {
        case .success(let response):
            // 헤더를 검사해서 토큰을 기기에 저장함
            return NetworkHandler.requestDecoded(by: response)
        case .failure(let failure):
            return .failure(.other(failure.localizedDescription))
        }
    }

    private func saveTokens(accessToken: AccessToken, refreshToken: RefreshToken) {
        guard let tokenManagableClient = apiClient as? TokenManagable else {
            return
        }

        tokenManagableClient.tokenManager.save(accessToken)
        tokenManagableClient.tokenManager.save(refreshToken)
    }
}
