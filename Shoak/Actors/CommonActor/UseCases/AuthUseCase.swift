//
//  AuthUseCase.swift
//  Shoak
//
//  Created by 정종인 on 7/29/24.
//

import Foundation

final class AuthUseCase {
    let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    func loginOrSignUp(credential: TMUserCredentialVO) async -> Result<Void, NetworkError> {
        let dto = toDTO(credential)
        let result = await authRepository.loginOrSignUp(loginOrSignUpDTO: dto)
        switch result {
        case .success:
            return .success(())
        case .failure(let failure):
            return .failure(failure)
        }
    }
}

extension AuthUseCase {
    private func toVO(_ dto: TMProfileDTO) -> TMProfileVO {
        TMProfileVO(name: dto.name, imageURL: dto.imageURL)
    }

    private func toDTO(_ vo: TMUserCredentialVO) -> TMLoginOrSignUpDTO {
        let deviceToken = TokenManager().getDeviceToken()?.token ?? ""
        return TMLoginOrSignUpDTO(
            identityToken: vo.token,
            name: vo.name,
            deviceToken: deviceToken
        )
    }
}
