//
//  LoginView.swift
//  Shoak
//
//  Created by 정종인 on 7/27/24.
//

import SwiftUI
import Lottie

struct LoginView: View {
    @Environment(AccountManager.self) private var accountManager
    @Environment(NavigationManager.self) private var navigationManager

    var body: some View {
        VStack {
            Spacer()

            LottieView(animation: .named("LogoAnimate"))
                .looping()
                .resizable()
                .frame(width: 280, height: 280)
                .background(Color.shoakYellow)
                .clipShape(Circle())
                .matchedGeometryEffect(id: "logo", in: navigationManager.namespace)

            Spacer()

            AppleLoginView(
                onSignInSuccess: { credential in
                    print("credential : \(credential)")
                    Task {
                        let result = await accountManager.loginOrSignUp(credential: credential)
                        if result == 200 {
                            navigationManager.setView(to: .checkMyProfile(onNext: {
                                navigationManager.setView(to: .friendList, saveHistory: false)
                            }), saveHistory: false)
                        } else if result == 201 {
                            navigationManager.setView(to: .checkMyProfile(onNext: {
#if APPCLIP
                                navigationManager.setView(to: .friendList, saveHistory: false)
#else
                                navigationManager.setView(to: .onboarding, saveHistory: false)
#endif
                            }), saveHistory: false)
                        }
                    }
                },
                onSignInFailure: { _ in
                    print("애플 로그인 실패 ㅠ")
                }
            )
            .frame(maxHeight: 54)
        }
        .padding()
        .onAppear {
            if accountManager.isLoggedIn() {
                navigationManager.setView(to: .friendList, saveHistory: false)
            }
        }
    }
}

#Preview {
    LoginView()
        .addEnvironmentsForPreview()
}
