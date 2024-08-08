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

#if os(iOS) && !APPCLIP
extension NavigationManager {
    enum SwitchableView: View, CaseIterable {
        case login
        case onboarding
        case friendList
        case settings
        case inviteFriends
        case editProfile
        case deleteFriends

        var body: some View {
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
            case .editProfile:
                EditProfileView()
            case .deleteFriends:
                DeleteFriendView()
            }
        }
    }
}
#elseif os(iOS) && APPCLIP
extension NavigationManager {
    enum SwitchableView: View, CaseIterable {
        case login
        case friendList
        case settings
        case inviteFriends
        case editProfile
        case deleteFriends

        var body: some View {
            switch self {
            case .login:
                LoginView()
            case .friendList:
                FriendListView()
            case .settings:
                SettingView()
            case .inviteFriends:
                InviteFriendsView()
            case .editProfile:
                EditProfileView()
            case .deleteFriends:
                DeleteFriendView()
            }
        }
    }
}
#elseif os(watchOS)
extension NavigationManager {
    enum SwitchableView: View, CaseIterable {
        case friendList

        var body: some View {
            switch self {
            case .friendList:
                WatchFriendListView()
            default:
                EmptyView()
            }
        }
    }
}
#endif
