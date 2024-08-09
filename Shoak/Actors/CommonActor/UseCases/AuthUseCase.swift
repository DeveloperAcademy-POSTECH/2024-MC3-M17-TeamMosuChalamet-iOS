//
//  AuthUseCase.swift
//  Shoak
//
//  Created by 정종인 on 7/29/24.
//

import Foundation

final class AuthUseCase {
    let authRepository: AuthRepository
    let tokenRepository: TokenRepository

    init(authRepository: AuthRepository, tokenRepository: TokenRepository) {
        self.authRepository = authRepository
        self.tokenRepository = tokenRepository
    }

    func loginOrSignUp(credential: TMUserCredentialVO) async -> Result<Void, NetworkError> {
        let result = await authRepository.loginOrSignUp(credential: toDTO(credential))
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
        TMProfileVO(id: dto.id, name: dto.name, imageURL: dto.imageURL)
    }

    private func toDTO(_ vo: TMUserCredentialVO) -> TMUserCredentialDTO {
        TMUserCredentialDTO(userID: vo.userID, name: vo.name, token: vo.token, authCode: vo.authCode)
    }
}
