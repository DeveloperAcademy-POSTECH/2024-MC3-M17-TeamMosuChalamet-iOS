//
//  AuthRepository.swift
//  Shoak
//
//  Created by 정종인 on 7/29/24.
//

import Foundation
import Moya

final class AuthRepository {
    let provider: MoyaProvider<AuthAPI>

    init(apiClient: APIClient) {
        self.provider = apiClient.resolve(for: AuthAPI.self)
    }

    func loginOrSignUp(loginOrSignUpDTO: TMLoginOrSignUpDTO) async -> Result<TMProfileDTO, NetworkError> {
        let response = await provider.request(.loginOrSignUp(tmLoginOrSignUpDTO: loginOrSignUpDTO))
        switch response {
        case .success(let success):
            return NetworkHandler.requestDecoded(by: success)
        case .failure(let failure):
            return .failure(.other(failure.localizedDescription))
        }
    }
}
