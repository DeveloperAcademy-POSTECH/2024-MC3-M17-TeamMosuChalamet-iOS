//
//  ShoakApp.swift
//  Shoak
//
//  Created by 정종인 on 7/23/24.
//

import SwiftUI

@main
struct ShoakApp: App {
    var body: some Scene {
        WindowGroup {
            //MyPageView(useCase: ShoakUseCase())
            AppleLoginView(useCase: AppleUseCase())
        }
    }
}
