//
//  WatchFriendListView.swift
//  ShoakWatch Watch App
//
//  Created by 정종인 on 7/25/24.
//

import SwiftUI

struct WatchFriendListView: View {
    @Environment(ShoakDataManager.self) private var shoakDataManager
    @Environment(NavigationManager.self) private var navigationManager

    var body: some View {
        VStack {
            List(shoakDataManager.friends, id: \.memberID) { member in
                Text("member name : \(member.name)")
            }

            Button("Go to Setting") {
                navigationManager.setView(to: .settings)
            }
        }
    }
}

#Preview {
    WatchFriendListView()
}
