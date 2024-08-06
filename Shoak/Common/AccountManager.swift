//
//  AccountManager.swift
//  Shoak
//
//  Created by 정종인 on 7/27/24.
//

import Foundation
import UIKit

@Observable
class AccountManager: @unchecked Sendable {
    static let shared = AccountManager()

    @ObservationIgnored let appleUseCase: AppleUseCase
    @ObservationIgnored private let authUseCase: AuthUseCase

    var profile: TMProfileVO?

    @ObservationIgnored private let tokenManager: TokenManager
    @ObservationIgnored private let userUseCase: UserUseCase

    private init() {
        self.appleUseCase = AppleUseCase()
        self.tokenManager = TokenManager.shared
        let apiClient = DefaultAPIClient(tokenManager: tokenManager)
        let userRepository = UserRepository(apiClient: apiClient)
        self.userUseCase = UserUseCase(userRepository: userRepository)
        let authRepository = AuthRepository(apiClient: apiClient)
        self.authUseCase = AuthUseCase(authRepository: authRepository)
    }

    public func loginOrSignUp(credential: TMUserCredentialVO) async -> Bool {
        let result = await authUseCase.loginOrSignUp(credential: credential)

        if case .success = result {
            return true
        }
        return false
    }
    
    public func refreshProfile() {
        Task {
            await getProfile()
        }
    }

    public func getProfile() async {
        let result = await userUseCase.getProfile()
        switch result {
        case .success(let success):
            self.profile = success
        case .failure(let failure):
            print("fail! : \(failure)")
        }
    }

    public func updateProfileImage(_ image: UIImage) async -> Result<TMProfileVO, NetworkError> {
        return await userUseCase.uploadProfileImage(image: image)
    }
}

extension AccountManager {
    func isLoggedIn() -> Bool {
//        accountUseCase.isLoggedIn()

        if tokenManager.getIdentityToken() != nil && tokenManager.getAccessToken() != nil {
            return true
        } else {
            return false
        }
    }
}
