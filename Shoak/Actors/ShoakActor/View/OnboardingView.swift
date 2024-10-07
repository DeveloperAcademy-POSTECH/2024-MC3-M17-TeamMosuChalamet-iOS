//
//  OnboardingView.swift
//  Shoak
//
//  Created by 정종인 on 7/27/24.
//

import SwiftUI
import AppIntents

struct OnboardingView: View {
    @Environment(NavigationManager.self) private var navigationManager
    @State private var currentPage: ContinuousView = .short1
    @State private var shortcutURL: URL?

    var body: some View {
        VStack(spacing: 0) {
            TopButtons(currentPage: $currentPage)

            Spacer()

            currentPage

            Spacer()

            if currentPage == .addShortcut, let url = shortcutURL {
                BottomButton {
                    withAnimation {
                        currentPage.next()
                    }
                }
                .padding(.vertical, 16)

                ShareLink(item: url, preview: .init("쇽 시작하기 단축어 추가하기", image: Image("ShoakLogoFilled"))) {
                    HStack(spacing: 16) {
                        Spacer()

                        Image(systemName: "chevron.right") // 중앙을 적절히 맞추기 위한 장치
                            .hidden()

                        Text("단축어 생성하기")
                            .font(.textButton)
                            .frame(maxHeight: 58)

                        Image(systemName: "chevron.right")

                        Spacer()
                    }
                    .background(Color.shoakNavy)
                    .foregroundStyle(Color.textWhite)
                    .buttonStyle(.plain)
                    .clipShapeBorder(RoundedRectangle(cornerRadius: 12), Color.strokeBlack, 1)
                }

            } else if currentPage == .finish {
                BottomButton {
                    withAnimation {
                        self.navigationManager.setView(to: .friendList)
                    }
                }
            } else {
                BottomButton {
                    withAnimation {
                        currentPage.next()
                    }
                }
            }


        }
        .padding()
        .onAppear {
            loadShortcut()
        }
    }

    struct TopButtons: View {
        @Environment(NavigationManager.self) private var navigationManager
        @Binding var currentPage: ContinuousView
        var body: some View {
            HStack {
                if currentPage != .short1 {
                    BackButton {
                        withAnimation {
                            self.currentPage = self.currentPage.prev()
                        }
                    }
                } else {
                    BackButton()
                        .hidden()
                }

                Spacer()

                Text(currentPage.title)
                    .font(.textPageTitle)

                Spacer()

                CloseButton {
                    navigationManager.setView(to: .friendList, saveHistory: false)
                }
            }
            .frame(maxHeight: 44)
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

// MARK: - Define Continuous View
enum ContinuousView: View, CaseIterable {
    case short1
    case short2
    case short3
    case short4
    case short5
    case addShortcut
    case watch1
    case watch2
    case watch3
    case watch4
    case watch5
    case watch6
    case watch7
    case watch8
    case finish

    var body: some View {
        switch self {
        case .short1:
            OnboardingShortcut1()
        case .short2:
            OnboardingShortcut2()
        case .short3:
            OnboardingShortcut3()
        case .short4:
            OnboardingShortcut4()
        case .short5:
            OnboardingShortcut5()
        case .addShortcut:
            AddShortcut()
        case .watch1:
            OnboardingWatch1()
        case .watch2:
            OnboardingWatch2()
        case .watch3:
            OnboardingWatch3()
        case .watch4:
            OnboardingWatch4()
        case .watch5:
            OnboardingWatch5()
        case .watch6:
            OnboardingWatch6()
        case .watch7:
            OnboardingWatch7()
        case .watch8:
            OnboardingWatch8()
        case .finish:
            FinishView()
        }
    }

    var label: LocalizedStringKey {
        switch self {
        default:
            LocalizedStringKey("다음")
        }
    }

    var title: LocalizedStringKey {
        switch self {
        case .short1, .short2, .short3, .short4, .short5, .addShortcut:
            LocalizedStringKey("단축어 설치")
        case .watch1, .watch2, .watch3, .watch4, .watch5, .watch6, .watch7, .watch8:
            LocalizedStringKey("Watch 설정")
        case .finish:
            LocalizedStringKey("Watch 설정 (마무리)")
        }
    }

    mutating func next() {
        self = self.next()
    }
}

// MARK: - Views for Onboarding
private struct OnboardingShortcut1: View {
    var body: some View {
        Image(.short1)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}
private struct OnboardingShortcut2: View {
    var body: some View {
        Image(.short2)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}
private struct OnboardingShortcut3: View {
    var body: some View {
        Image(.short3)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}
private struct OnboardingShortcut4: View {
    var body: some View {
        Image(.short4)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}
private struct OnboardingShortcut5: View {
    var body: some View {
        Image(.short5)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}
private struct AddShortcut: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("단축어를 생성합니다")
                .font(.textListTitle)
            Image(.shortcut)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(80)
        }
    }
}
private struct OnboardingWatch1: View {
    var body: some View {
        Image(.watch1)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}
private struct OnboardingWatch2: View {
    var body: some View {
        Image(.watch2)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}
private struct OnboardingWatch3: View {
    var body: some View {
        Image(.watch3)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}
private struct OnboardingWatch4: View {
    var body: some View {
        Image(.watch4)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}
private struct OnboardingWatch5: View {
    var body: some View {
        Image(.watch5)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}
private struct OnboardingWatch6: View {
    var body: some View {
        Image(.watch6)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}
private struct OnboardingWatch7: View {
    var body: some View {
        Image(.watch7)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}
private struct OnboardingWatch8: View {
    var body: some View {
        Image(.watch8)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}
private struct FinishView: View {
    var body: some View {
        Image(.watch9)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

#Preview {
    OnboardingView()
        .addEnvironmentsForPreview()
}
