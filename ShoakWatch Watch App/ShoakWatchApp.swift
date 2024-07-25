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
    private let navigationModel: NavigationModel

    init() {
        let shoakDataManager = ShoakDataManager.shared
        self.shoakDataManager = shoakDataManager

        let navigationModel = NavigationModel()
        self.navigationModel = navigationModel

        AppDependencyManager.shared.add(dependency: shoakDataManager)
        AppDependencyManager.shared.add(dependency: navigationModel)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(shoakDataManager)
                .environment(navigationModel)
        }
    }
}
