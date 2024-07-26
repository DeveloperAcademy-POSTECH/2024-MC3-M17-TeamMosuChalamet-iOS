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
            //RootView()
                //.environment(shoakDataManager)
                //.environment(navigationModel)
            //MyPageView(useCase: ShoakUseCase())
            AppleLoginView(useCase: AppleUseCase())
        }
    }
}
