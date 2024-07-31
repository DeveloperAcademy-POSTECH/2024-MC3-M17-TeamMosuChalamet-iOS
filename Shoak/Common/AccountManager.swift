//
//  AccountManager.swift
//  Shoak
//
//  Created by 정종인 on 7/27/24.
//

import Foundation

@Observable
class AccountManager: @unchecked Sendable {
    static let shared = AccountManager()

    @ObservationIgnored private let accountUseCase: AccountUseCase
    @ObservationIgnored let appleUseCase: AppleUseCase
    @ObservationIgnored private let authUseCase: AuthUseCase

    var profile: TMProfileVO?

    private let tokenManager: TokenManager

    private init() {
        self.accountUseCase = AccountUseCase()
        self.appleUseCase = AppleUseCase()
        self.tokenManager = TokenManager()
        let apiClient = DefaultAPIClient(tokenManager: tokenManager)
        let authRepository = AuthRepository(apiClient: apiClient)
        self.authUseCase = AuthUseCase(authRepository: authRepository)
    }

    public func loginOrSignUp(credential: TMUserCredentialVO) async -> Bool {
        let result = await authUseCase.loginOrSignUp(credential: credential)

        if case .success(let profile) = result {
            self.profile = profile
            return true
        }
        return false
    }
}

extension AccountManager {
    func isLoggedIn() -> Bool {
//        accountUseCase.isLoggedIn()

        if tokenManager.getIdentityToken() != nil {
            return true
        } else {
            return false
        }
    }
}
