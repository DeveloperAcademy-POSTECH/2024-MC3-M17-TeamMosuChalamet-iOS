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
    private var shoakDataManager: ShoakDataManager
    private var accountManager: AccountManager
    private let navigationManager: NavigationManager

    init() {
        let shoakDataManager = ShoakDataManager.shared
        self.shoakDataManager = shoakDataManager

        let accountManager = AccountManager.shared
        self.accountManager = accountManager

        let navigationManager = NavigationManager()
        self.navigationManager = navigationManager

        AppDependencyManager.shared.add(dependency: shoakDataManager)
        AppDependencyManager.shared.add(dependency: accountManager)
        AppDependencyManager.shared.add(dependency: navigationManager)
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(shoakDataManager)
                .environment(accountManager)
                .environment(navigationManager)
        }
    }
}