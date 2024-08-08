//
//  ShoakApp.swift
//  Shoak
//
//  Created by 정종인 on 7/23/24.
//

import SwiftUI
import AppIntents

@main
struct ShoakApp: App {
    @UIApplicationDelegateAdaptor var delegate: ShoakAppDelegate
    @Namespace var namespace
    private var shoakDataManager: ShoakDataManager
    private var accountManager: AccountManager
    private var navigationManager: NavigationManager {
        NavigationManager(namespace: namespace)
    }
    private var invitationManager: InvitationManager
    private var watchConnectivityManager: WatchConnectivityManager

    init() {
        let tokenRepository = KeychainTokenRepository()
        let tokenRefreshRepository = DefaultTokenRefreshRepository(tokenRepository: tokenRepository)
        let tokenUseCase = TokenUseCase(tokenRepository: tokenRepository, tokenRefreshRepository: tokenRefreshRepository)

        let apiClient = DefaultAPIClient(tokenRepository: tokenRepository, tokenRefreshRepository: tokenRefreshRepository)

        let authRepository = AuthRepository(apiClient: apiClient)
        let shoakRepository = ShoakRepository(apiClient: apiClient)
        let userRepository = UserRepository(apiClient: apiClient)
        let invitationRepository = InvitationRepository(apiClient: apiClient)

        let appleUseCase = AppleUseCase()
        let authUseCase = AuthUseCase(authRepository: authRepository, tokenRepository: tokenRepository)
        let userUseCase = UserUseCase(userRepository: userRepository)
        let shoakUseCase = SendShoakUseCase(shoakRepository: shoakRepository)
        let invitationUseCase = InvitationUseCase(invitationRepository: invitationRepository)

        let accountManager = AccountManager(appleUseCase: appleUseCase, authUseCase: authUseCase, userUseCase: userUseCase, tokenUseCase: tokenUseCase)
        let shoakDataManager = ShoakDataManager(userUseCase: userUseCase, shoakUseCase: shoakUseCase)
        let invitationManager = InvitationManager(invitationUseCase: invitationUseCase)

        let watchConnectivityManager = WatchConnectivityManager.shared
        self.watchConnectivityManager = watchConnectivityManager

        self.shoakDataManager = shoakDataManager
        self.accountManager = accountManager
        self.invitationManager = invitationManager
        self.watchConnectivityManager = watchConnectivityManager

//        AppDependencyManager.shared.add(dependency: shoakDataManager)
//        AppDependencyManager.shared.add(dependency: accountManager)
//        AppDependencyManager.shared.add(dependency: navigationManager)
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(shoakDataManager)
                .environment(accountManager)
                .environment(navigationManager)
                .environment(invitationManager)
                .environment(watchConnectivityManager)
                .onOpenURL { url in
                    handleDeepLink(url: url)
                    navigationManager.setView(to: .friendList)
                }
        }
    }

    private func handleDeepLink(url: URL) {
        print("Deep link URL: \(url.absoluteString)")

        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
        let memberID = components.queryItems?.first(where: { $0.name == "memberID" })?.value,
        let memberIDToInt64 = Int64(memberID, radix: 10) else {
            return
        }

        navigationManager.invitation = memberIDToInt64
    }
}
