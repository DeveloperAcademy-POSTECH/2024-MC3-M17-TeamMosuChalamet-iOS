//
//  ContentView.swift
//  ShoakWatch Watch App
//
//  Created by 정종인 on 7/25/24.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @Environment(NavigationManager.self) private var navigationManager
    var body: some View {
        navigationManager.view
            .task {
                let center = UNUserNotificationCenter.current()
                _ = try? await center.requestAuthorization(
                    options: [.alert, .sound, .badge]
                )
            }
    }
}

#Preview {
    ContentView()
}
