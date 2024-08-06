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
    private var shoakDataManager: ShoakDataManager
    private var accountManager: AccountManager
    private let navigationManager: NavigationManager
    private var invitationManager: InvitationManager
    private var watchConnectivityManager: WatchConnectivityManager

    init() {
        let shoakDataManager = ShoakDataManager.shared
        self.shoakDataManager = shoakDataManager

        let accountManager = AccountManager.shared
        self.accountManager = accountManager

        let navigationManager = NavigationManager.shared
        self.navigationManager = navigationManager
        
        let invitationManager = InvitationManager.shared
        self.invitationManager = invitationManager

        let watchConnectivityManager = WatchConnectivityManager.shared
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

        NavigationManager.shared.invitation = memberIDToInt64
    }
}
