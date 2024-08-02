//
//  StartShoakProcess.swift
//  Shoak
//
//  Created by 정종인 on 7/24/24.
//

import Foundation
import AppIntents

struct StartShoakProcess: AppIntent {
    static var title: LocalizedStringResource = "쇽! 시작하기"
    static var description: IntentDescription? = IntentDescription(stringLiteral: "쇽을 시작하여 친구를 불러보세요!")
    static var openAppWhenRun: Bool = true
    static var authenticationPolicy: IntentAuthenticationPolicy = .requiresLocalDeviceAuthentication

    func perform() async throws -> some IntentResult {
        return .result()
    }

//    @Dependency
//    private var navigationManager: NavigationManager
//  추후 App Dependency Manager를 이용해서 다른 Intent 구성.
//    @Dependency
//    private var dataManager: ShoakDataManager
}
