//
//  AddEnvorinmentsForPreview.swift
//  Shoak
//
//  Created by 정종인 on 8/8/24.
//

import SwiftUI

struct AddEnvorinmentsForPreview: ViewModifier {
    func body(content: Content) -> some View {
        let apiClient = TestAPIClient()

        let tokenRepository = KeychainTokenRepository()
        let authRepository = AuthRepository(apiClient: apiClient)
        let shoakRepository = ShoakRepository(apiClient: apiClient)
        let userRepository = UserRepository(apiClient: apiClient)
        let invitationRepository = InvitationRepository(apiClient: apiClient)
        let tokenRefreshRepository = DefaultTokenRefreshRepository(tokenRepository: tokenRepository)

        let appleUseCase = AppleUseCase(tokenRepository: tokenRepository)
        let authUseCase = AuthUseCase(authRepository: authRepository, tokenRepository: tokenRepository)
        let userUseCase = UserUseCase(userRepository: userRepository)
        let shoakUseCase = SendShoakUseCase(shoakRepository: shoakRepository)
        let invitationUseCase = InvitationUseCase(invitationRepository: invitationRepository)
        let tokenUseCase = TokenUseCase(tokenRepository: tokenRepository, tokenRefreshRepository: tokenRefreshRepository)

        let navigationManager = NavigationManager.shared
        let accountManager = AccountManager(appleUseCase: appleUseCase, authUseCase: authUseCase, userUseCase: userUseCase, tokenUseCase: tokenUseCase)
        let shoakDataManager = ShoakDataManager(userUseCase: userUseCase, shoakUseCase: shoakUseCase)
        let invitationManager = InvitationManager(invitationUseCase: invitationUseCase)
        return content
            .environment(navigationManager)
            .environment(accountManager)
            .environment(shoakDataManager)
            .environment(invitationManager)
    }
}

extension View {
    func addEnvironmentsForPreview() -> some View {
        modifier(AddEnvorinmentsForPreview())
    }
}
