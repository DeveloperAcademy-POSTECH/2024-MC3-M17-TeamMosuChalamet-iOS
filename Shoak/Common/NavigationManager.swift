//
//  NavigationManager.swift
//  Shoak
//
//  Created by 정종인 on 7/25/24.
//

import SwiftUI

@MainActor
@Observable
class NavigationManager {
    static let shared = NavigationManager()
    var view: SwitchableView

    var invitation: TMMemberID?

    private init() {
        self.view = .login
    }

    public func nextPhase() {
        self.view = self.view.next()
    }

    public func setView(to view: SwitchableView, with animation: Animation = .default) {
        withAnimation(animation) {
            self.view = view
        }
    }
}

extension NavigationManager {
    enum SwitchableView: View, CaseIterable {
        case login
        case onboarding
        case friendList
        case settings
        case inviteFriends
        case deleteFriends

        var body: some View {
#if os(iOS)
            switch self {
            case .login:
                LoginView()
            case .onboarding:
                OnboardingView()
            case .friendList:
                FriendListView()
            case .settings:
                SettingView()
            case .inviteFriends:
                InviteFriendsView()
            case .deleteFriends:
                DeleteFriendView()
            }
#elseif os(watchOS)
            switch self {
            case .friendList:
                  EmptyView()
//                WatchFriendListView()
            case .settings:
                WatchSettingView()
            default:
                WatchFriendListView()
//                EmptyView()
            }
#endif
        }
    }
}
