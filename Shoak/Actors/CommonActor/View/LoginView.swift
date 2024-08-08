//
//  LoginView.swift
//  Shoak
//
//  Created by 정종인 on 7/27/24.
//

import SwiftUI

struct LoginView: View {
    @Environment(AccountManager.self) private var accountManager
    @Environment(NavigationManager.self) private var navigationManager

    var body: some View {
        VStack {
            Spacer()

            Image(.shoakIcon)
                .resizable()
                .frame(width: 280, height: 280)

            Spacer()

            AppleLoginView(
                onSignInSuccess: { credential in
                    print("credential : \(credential)")
                    Task {
                        let result = await accountManager.loginOrSignUp(credential: credential)
                        if result {
#if APPCLIP
                            navigationManager.setView(to: .friendList)
#else
                            navigationManager.setView(to: .onboarding)
#endif
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
                navigationManager.setView(to: .friendList)
            }
        }
    }
}

#Preview {
    LoginView()
        .addEnvironmentsForPreview()
}
