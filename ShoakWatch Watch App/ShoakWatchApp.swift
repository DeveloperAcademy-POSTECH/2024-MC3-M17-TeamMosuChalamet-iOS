//
//  ShoakWatchApp.swift
//  ShoakWatch Watch App
//
//  Created by 정종인 on 7/25/24.
//

import SwiftUI
import AppIntents

@main
struct ShoakWatch_Watch_AppApp: App {
    private var shoakDataManager: ShoakDataManager
    private let navigationManager: NavigationManager

    init() {
        let shoakDataManager = ShoakDataManager.shared
        self.shoakDataManager = shoakDataManager

        let navigationManager = NavigationManager()
        self.navigationManager = navigationManager

        AppDependencyManager.shared.add(dependency: shoakDataManager)
        AppDependencyManager.shared.add(dependency: navigationManager)
    }
    

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(shoakDataManager)
                .environment(navigationManager)
        }
        WKNotificationScene(controller: WatchNotificationController.self, category: "몰라")
    }
}
