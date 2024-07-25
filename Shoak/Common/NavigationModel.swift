//
//  NavigationModel.swift
//  Shoak
//
//  Created by 정종인 on 7/25/24.
//

import SwiftUI

@MainActor
@Observable
class NavigationModel {
    var view: SwitchableView

    init() {
        self.view = .friendList
    }

    public func nextPhase() {
        self.view = self.view.next()
    }

    public func setView(to view: SwitchableView) {
        self.view = view
    }
}

extension NavigationModel {
    enum SwitchableView: View, CaseIterable {
        case friendList
        case settings

        var body: some View {
#if os(iOS)
            switch self {
            case .friendList:
                WatchFriendListView()
            case .settings:
                WatchSettingView()
            }
#elseif os(watchOS)
            switch self {
            case .friendList:
                WatchFriendListView()
            case .settings:
                WatchSettingView()
            }
#endif
        }
    }
}
