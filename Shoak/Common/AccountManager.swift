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

    /// return : login result code
    ///     200 : 로그인 성공
    ///     201 : 회원가입 성공
    ///     other : 실패
    public func loginOrSignUp(credential: TMUserCredentialVO) async -> Int {
        tokenUseCase.save(identityToken: credential.token)
#if os(iOS)
        await UIApplication.shared.registerForRemoteNotifications()
        // 5초 동안 getDeviceToken()이 nil이 아닌지 확인
        let deviceTokenObtained = await waitForDeviceToken(timeout: 5.0)

        // 만약 5초 내에 deviceToken이 설정되지 않으면 false 반환
        if !deviceTokenObtained {
            return 401
        }
#endif
        let result = await authUseCase.loginOrSignUp(credential: credential)

        if case .success(let code) = result {
            return code
        }

        return 404
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
        if case .success = response {
            tokenUseCase.deleteAllTokens()
#if os(iOS)
            await UIApplication.shared.unregisterForRemoteNotifications()
#endif
        }
        return response
    }

    public func changeName(_ name: String) async -> Result<Void, NetworkError> {
        let response = await userUseCase.changeName(name)
        return response
    }
}

extension AccountManager {
    private func waitForDeviceToken(timeout: TimeInterval) async -> Bool {
        let startTime = Date().timeIntervalSince1970

        while Date().timeIntervalSince1970 - startTime < timeout {
            // tokenUseCase.getDeviceToken()이 nil이 아닌지 확인
            if tokenUseCase.getDeviceToken() != nil {
                return true
            }
            // 100ms 동안 대기
            try? await Task.sleep(nanoseconds: 100_000_000)
        }

        // 타임아웃이 발생하면 false 반환
        return false
    }
    func isLoggedIn() -> Bool {
        tokenUseCase.isLoggedIn()
    }
}
