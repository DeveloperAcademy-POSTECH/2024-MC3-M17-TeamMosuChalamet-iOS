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
    var namespace: Namespace.ID
    var view: SwitchableView
    var visitHistory: [SwitchableView] = []

    var invitation: TMMemberID?

    public init(namespace: Namespace.ID) {
        self.view = .login
        self.namespace = namespace

        NotificationCenter.default.addObserver(forName: .toLoginView, object: nil, queue: nil) { _ in
            print("Navigation to login view!!")
            DispatchQueue.main.async {
                self.view = .login
            }
        }
    }

    public func setView(to view: SwitchableView, with animation: Animation = .default, saveHistory: Bool = true) {
        if saveHistory {
            visitHistory.append(self.view)
        }
        withAnimation(animation) {
            self.view = view
        }
    }

    public func clearHistory() {
        self.visitHistory = []
    }

    public func setPrevView(with animation: Animation = .default) {
        withAnimation(animation) {
            if let lastVisitedView = 
                self.visitHistory.popLast() {
                self.view = lastVisitedView
            }
        }
    }
}

#if os(iOS) && !APPCLIP
extension NavigationManager {
    enum SwitchableView: View {
        case login
        case checkMyProfile(onNext: () -> Void = {})
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
            case .checkMyProfile(let onNext):
                CheckMyProfileView(onNext: onNext)
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
    enum SwitchableView: View {
        case login
        case checkMyProfile(onNext: () -> Void = {})
        case friendList
        case settings
        case inviteFriends
        case editProfile
        case deleteFriends

        var body: some View {
            switch self {
            case .login:
                LoginView()
            case .checkMyProfile(let onNext):
                CheckMyProfileView(onNext: onNext)
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
        case login
        case friendList

        var body: some View {
            switch self {
            case .login, .friendList:
                WatchFriendListView()
            default:
                EmptyView()
            }
        }
    }
}
#endif
