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

    func loginOrSignUp() async -> Result<Void, NetworkError> {
        let result = await authRepository.loginOrSignUp()
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
}
