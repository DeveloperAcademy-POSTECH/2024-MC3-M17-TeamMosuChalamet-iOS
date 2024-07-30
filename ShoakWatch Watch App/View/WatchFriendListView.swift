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
        
        WatchFriendView()
      
            }
        }
    
#Preview {
    WatchFriendListView()
        .environment(ShoakDataManager.shared)
        .environment(NavigationManager())
}
