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

            Image(systemName: "star.fill")
                .resizable()
                .padding()
                .frame(width: 206, height: 206)
                .background(Color.shoakYellow)
                .clipShape(Circle())

            Spacer()

            AppleLoginView(
                onSignInSuccess: { credential in
                    Task {
                        let result = await accountManager.loginOrSignUp(credential: credential)
                        if result {
                            navigationManager.setView(to: .onboarding)
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
