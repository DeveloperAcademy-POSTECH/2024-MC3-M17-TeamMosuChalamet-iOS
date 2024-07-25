//
//  SettingView.swift
//  ShoakWatch Watch App
//
//  Created by 정종인 on 7/25/24.
//

import SwiftUI

struct WatchSettingView: View {
    @Environment(NavigationModel.self) private var navigationModel
    var body: some View {
        Text("Setting")

        Button("Go to Friend List") {
            navigationModel.setView(to: .friendList)
        }
    }
}

#Preview {
    WatchSettingView()
}
