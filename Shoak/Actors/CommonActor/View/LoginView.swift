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
        VStack(spacing: 32) {
            Button("(상황 가정 : 처음 로그인 시)\n온보딩 띄우는 로그인") {
                navigationManager.setView(to: .onboarding)
            }

            Button("(상황 가정 : 재로그인 시)\n바로 친구창으로 가는 로그인") {
                navigationManager.setView(to: .friendList)
            }

            AppleLoginView(useCase: AppleUseCase())
                .frame(maxHeight: 200)
        }
        .onAppear {
            if accountManager.isLoggedIn {
                navigationManager.setView(to: .friendList)
            }
        }
    }
}
