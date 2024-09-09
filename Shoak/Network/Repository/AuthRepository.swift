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

    func loginOrSignUp(credential: TMUserCredentialDTO) async -> Result<Int, NetworkError> {
        let response = await provider.request(.loginOrSignUp(credential: credential))
        switch response {
        case .success(let response):
            return .success(response.statusCode)
        case .failure(let failure):
            return .failure(.other(failure.localizedDescription))
        }
    }
}
