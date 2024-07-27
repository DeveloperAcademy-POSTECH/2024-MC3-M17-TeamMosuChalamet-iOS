//
//  SettingView.swift
//  ShoakWatch Watch App
//
//  Created by 정종인 on 7/25/24.
//

import SwiftUI

struct WatchSettingView: View {
    @Environment(NavigationManager.self) private var navigationManager
    var body: some View {
        Text("Setting")

        Button("Go to Friend List") {
            navigationManager.setView(to: .friendList)
        }
    }
}

#Preview {
    WatchSettingView()
}
