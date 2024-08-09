//
//  RootView.swift
//  Shoak
//
//  Created by 정종인 on 7/25/24.
//

import SwiftUI

struct RootView: View {
    @Environment(NavigationManager.self) private var navigationManager
    @State private var isShowingSplash: Bool = true
    var body: some View {
        ZStack {
            Color.bgGray.ignoresSafeArea()

            navigationManager.view

            if isShowingSplash {
                SplashView()
                    .zIndex(1)
                    .transition(.opacity)
            }
        }
        .task {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    isShowingSplash.toggle()
                }
            }
        }
    }
}

import Lottie

struct SplashView: View {
    @Environment(NavigationManager.self) private var navigationManager
    var body: some View {
        ZStack {
            Color.shoakYellow.ignoresSafeArea()

            LottieView(animation: .named("LogoAnimate"))
                .looping()
                .resizable()
                .frame(width: 280, height: 280)
                .matchedGeometryEffect(id: "logo", in: navigationManager.namespace)
        }
    }
}

#Preview {
    RootView()
        .addEnvironmentsForPreview()
}
