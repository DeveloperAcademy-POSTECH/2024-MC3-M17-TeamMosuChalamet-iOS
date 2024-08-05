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
            TopButtons(currentPage: $currentPage)

            Spacer()

            currentPage

            Spacer()

            BottomButtons(currentPage: $currentPage)
        }
        .padding()
    }

    struct TopButtons: View {
        @Binding var currentPage: ContinuousView
        var body: some View {
            HStack {
                if currentPage != .addShortcut {
                    BackButton {
                        withAnimation {
                            self.currentPage = self.currentPage.prev()
                        }
                    }
                }

                Spacer()
            }
            .frame(maxHeight: 44)
        }
    }

    struct BottomButtons: View {
        @Environment(NavigationManager.self) private var navigationManager
        @Binding var currentPage: ContinuousView
        var body: some View {
            Button {
                buttonAction()
            } label: {
                Text("다음")
                    .font(.textButton)
                    .frame(maxWidth: .infinity, maxHeight: 58)
                    .background(Color.shoakYellow)
                    .overlay {
                        Image(systemName: "chevron.right")
                            .offset(x: 30)
                    }
            }
            .buttonStyle(.plain)
            .clipShapeBorder(RoundedRectangle(cornerRadius: 12), Color.strokeBlack, 1)
        }

        func buttonAction() {
            withAnimation {
                switch self.currentPage {
                case .finish:
                    Task { await self.navigationManager.setView(to: .friendList) }
                default:
                    self.currentPage = self.currentPage.next()
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

        var label: String {
            switch self {
            default:
                "다음"
            }
        }
    }
}

// MARK: - Views for Onboarding

import AppIntents
private struct AddShortcutView: View {
    @State private var showActivityView = false
    @State private var shortcutURL: URL?
    var body: some View {
        VStack {
            Text("Add Shortcut")
            if let url = shortcutURL {
                ShareLink(item: url, preview: .init("쇽 시작하기 단축어 추가하기", image: Image("ShoakLogoFilled"))) {
                    Label("Shoak 단축어 추가하기!!!", systemImage: "tray.and.arrow.down.fill")
                }
            }

            ShortcutsLink()
        }
        .sheet(isPresented: $showActivityView, onDismiss: {
            self.shortcutURL = nil
        }) {
            if let url = shortcutURL {
                ShareLink(item: url)
            } else {
                Text("No shortcut available")
            }
        }
        .onAppear {
            loadShortcut()
        }
    }
    func loadShortcut() {
        if let url = Bundle.main.url(forResource: "쇽 시작하기", withExtension: "shortcut") {
            self.shortcutURL = url
        } else {
            print("StartShoakShortcut.shortcut file not found in bundle.")
        }
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

#Preview {
    OnboardingView()
        .addEnvironmentsForPreview()
}
