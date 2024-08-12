//
//  OnboardingView.swift
//  Shoak
//
//  Created by 정종인 on 7/27/24.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(NavigationManager.self) private var navigationManager
    @State private var currentPage: ContinuousView = .profile

    var body: some View {
        VStack(spacing: 0) {
            TopButtons(currentPage: $currentPage)

            currentPage

            BottomButtons(currentPage: $currentPage)
        }
        .padding()
    }

    struct TopButtons: View {
        @Binding var currentPage: ContinuousView
        var body: some View {
            HStack {
                if currentPage != .profile {
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
            { await navigationManager.setView(to: .friendList, saveHistory: false) }
        default:
            { currentPage = currentPage.next() }
        }
    }
}

// MARK: - Define Continuous View
extension OnboardingView {
    enum ContinuousView: View, CaseIterable {
        case profile
        case addShortcut
        case turnOnWatchApp
        case configureAccessibility
        case activateAssistiveTouch1
        case activateAssistiveTouch2
        case activateHandGestureView1
        case activateHandGestureView2
        case handGestureCustomView
        case finish

        var body: some View {
            switch self {
            case .profile:
                OnboardingProfileView()
            case .addShortcut:
                AddShortcutView()
            case .turnOnWatchApp:
                TurnOnWatchAppView()
            case .configureAccessibility:
                ConfigureAccessibilityView()
            case .activateAssistiveTouch1:
                ActivateAssistiveTouchView1()
            case .activateAssistiveTouch2:
                ActivateAssistiveTouchView2()
            case .activateHandGestureView1:
                ActivateHandGestureView1()
            case .activateHandGestureView2:
                ActivateHandGestureView2()
            case .handGestureCustomView:
                HandGestureCustomView()
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
private struct OnboardingProfileView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("다음 프로필로 시작합니다")
                .font(.textListTitle)
                .foregroundStyle(Color.textBlack)
                .multilineTextAlignment(.center)
                .padding(.bottom, 35)
            MyProfileView()
            Spacer()
        }
    }
}

import AppIntents
private struct AddShortcutView: View {
    @State private var showActivityView = false
    @State private var shortcutURL: URL?
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Text("아래 단축어를 클릭해서\n단축어 추가를 해주세요.")
                .font(.textListTitle)
                .foregroundStyle(Color.textBlack)
                .multilineTextAlignment(.center)
                .padding(.bottom, 35)
            
            if let url = shortcutURL {
                ShareLink(item: url, preview: .init("쇽 시작하기 단축어 추가하기", image: Image("ShoakLogoFilled"))) {
                    Image("shortcut")
                }
            }
            
            Text("앱 실행을 위해 생성하는 단축어입니다.")
                .font(.textListTitle)
                .foregroundStyle(Color.textBlack)
                .multilineTextAlignment(.center)
                .padding(.top, 48)
            
            Spacer()
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
        VStack(spacing: 0) {
            Spacer()
            
            Image(.watch)
            
            Text("‘워치'앱을 켜주세요")
                .font(.textListTitle)
                .foregroundStyle(Color.textBlack)
                .padding(.top, 80)
            
            Spacer()
        }
    }
}

private struct ConfigureAccessibilityView: View {
    var body: some View {
        Image(.ob1)
            .resizable()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 30)
            .padding(.vertical, 10)
    }
}

private struct ActivateAssistiveTouchView1: View {
    var body: some View {
        Image(.ob2)
            .resizable()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 30)
            .padding(.vertical, 10)
    }
}

private struct ActivateAssistiveTouchView2: View {
    var body: some View {
        Image(.ob3)
            .resizable()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 30)
            .padding(.vertical, 10)
    }
}

private struct ActivateHandGestureView1: View {
    var body: some View {
        Image(.ob4)
            .resizable()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 30)
            .padding(.vertical, 10)
    }
}

private struct ActivateHandGestureView2: View {
    var body: some View {
        Image(.ob5)
            .resizable()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 30)
            .padding(.vertical, 10)
    }
}

private struct HandGestureCustomView: View {
    var body: some View {
        Image(.ob6)
            .resizable()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 30)
            .padding(.vertical, 10)
    }
}

private struct FinishView: View {
    var body: some View {
        Image(.ob7)
            .resizable()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 30)
            .padding(.vertical, 10)
    }
}

#Preview {
    OnboardingView()
        .addEnvironmentsForPreview()
}
