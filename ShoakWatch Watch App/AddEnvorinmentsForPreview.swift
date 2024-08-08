//
//  AddEnvorinmentsForPreview.swift
//  Shoak
//
//  Created by 정종인 on 8/6/24.
//

import SwiftUI

struct AddEnvorinmentsForPreview: ViewModifier {
    @Namespace var namespace
    func body(content: Content) -> some View {
        let apiClient = TestAPIClient()

        let tokenRepository = KeychainTokenRepository()
        let authRepository = AuthRepository(apiClient: apiClient)
        let shoakRepository = ShoakRepository(apiClient: apiClient)
        let userRepository = UserRepository(apiClient: apiClient)
        let tokenRefreshRepository = DefaultTokenRefreshRepository(tokenRepository: tokenRepository)

        let appleUseCase = AppleUseCase()
        let authUseCase = AuthUseCase(authRepository: authRepository, tokenRepository: tokenRepository)
        let userUseCase = UserUseCase(userRepository: userRepository)
        let shoakUseCase = SendShoakUseCase(shoakRepository: shoakRepository)
        let tokenUseCase = TokenUseCase(tokenRepository: tokenRepository, tokenRefreshRepository: tokenRefreshRepository)

        let navigationManager = NavigationManager(namespace: namespace)
        let accountManager = AccountManager(appleUseCase: appleUseCase, authUseCase: authUseCase, userUseCase: userUseCase, tokenUseCase: tokenUseCase)
        let shoakDataManager = ShoakDataManager(userUseCase: userUseCase, shoakUseCase: shoakUseCase)
        return content
            .environment(navigationManager)
            .environment(accountManager)
            .environment(shoakDataManager)
    }
}

extension View {
    func addEnvironmentsForPreview() -> some View {
        modifier(AddEnvorinmentsForPreview())
    }
}
