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

    private init() {
        self.accountUseCase = AccountUseCase()
        self.appleUseCase = AppleUseCase()
        let apiClient = TestAPIClient() // TODO: Default로 바꾸기!
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

// MARK: - Computed Properties
extension AccountManager {
    var isLoggedIn: Bool {
        accountUseCase.isLoggedIn()
    }
}
