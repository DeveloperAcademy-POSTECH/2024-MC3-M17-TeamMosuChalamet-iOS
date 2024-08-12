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

    var profile: TMProfileVO? = nil

    @ObservationIgnored let appleUseCase: AppleUseCase
    @ObservationIgnored private let authUseCase: AuthUseCase
    @ObservationIgnored private let userUseCase: UserUseCase
    @ObservationIgnored private let tokenUseCase: TokenUseCase

    init(appleUseCase: AppleUseCase, authUseCase: AuthUseCase, userUseCase: UserUseCase, tokenUseCase: TokenUseCase) {
        self.appleUseCase = appleUseCase
        self.authUseCase = authUseCase
        self.userUseCase = userUseCase
        self.tokenUseCase = tokenUseCase
    }

    public func loginOrSignUp(credential: TMUserCredentialVO) async -> Bool {
        tokenUseCase.save(identityToken: credential.token)
#if os(iOS)
        if tokenUseCase.getDeviceToken() == nil {
            await UIApplication.shared.registerForRemoteNotifications()
        }
#endif
        let result = await authUseCase.loginOrSignUp(credential: credential)

        if case .success = result {
            return true
        }

        tokenUseCase.deleteAllTokensWithoutDeviceToken()
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

    public func logout() {
        tokenUseCase.deleteAllTokens()
#if os(iOS)
        UIApplication.shared.unregisterForRemoteNotifications()
#endif
    }

    public func signOut() async -> Result<Void, NetworkError> {
        let response = await userUseCase.signOut()
        tokenUseCase.deleteAllTokensWithoutDeviceToken()
        return response
    }

    public func changeName(_ name: String) async -> Result<Void, NetworkError> {
        let response = await userUseCase.changeName(name)
        return response
    }
}

extension AccountManager {
    func isLoggedIn() -> Bool {
        tokenUseCase.isLoggedIn()
    }
}
