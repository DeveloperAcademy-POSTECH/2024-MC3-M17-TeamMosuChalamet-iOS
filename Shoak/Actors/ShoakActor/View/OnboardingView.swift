//
//  OnboardingView.swift
//  Shoak
//
//  Created by 정종인 on 7/27/24.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(NavigationManager.self) private var navigationManager
    @State private var currentPage: ContinuousView = .addShortcut

    var body: some View {
        VStack(spacing: 32) {
            currentPage

            Button(currentActionLabel) {
                Task {
                    await currentAction()
                }
            }
        }
    }
}

// MARK: - Computed Properties for currentPage
extension OnboardingView {
    var currentActionLabel: String {
        switch currentPage {
        case .finish:
            "친구들 보러 가기"
        default:
            "다음"
        }
    }

    var currentAction: () async -> Void {
        switch currentPage {
        case .finish:
            { await navigationManager.setView(to: .friendList) }
        default:
            { currentPage = currentPage.next() }
        }
    }
}

// MARK: - Define Continuous View
extension OnboardingView {
    enum ContinuousView: View, CaseIterable {
        case addShortcut
        case turnOnWatchApp
        case configureAccessibility
        case activateAssistiveTouch
        case finish

        var body: some View {
            switch self {
            case .addShortcut:
                AddShortcutView()
            case .turnOnWatchApp:
                TurnOnWatchAppView()
            case .configureAccessibility:
                ConfigureAccessibilityView()
            case .activateAssistiveTouch:
                ActivateAssistiveTouchView()
            case .finish:
                FinishView()
            }
        }
    }
}

// MARK: - Views for Onboarding
private struct AddShortcutView: View {
    var body: some View {
        Text("Add Shortcut")
    }
}

private struct TurnOnWatchAppView: View {
    var body: some View {
        Text("TurnOnWatchAppView")
    }
}

private struct ConfigureAccessibilityView: View {
    var body: some View {
        Text("Configure Accessibility")
    }
}

private struct ActivateAssistiveTouchView: View {
    var body: some View {
        Text("ActivateAssistiveTouchView")
    }
}

private struct FinishView: View {
    var body: some View {
        Text("Onboarding Finish!")
    }
}
