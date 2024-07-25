//
//  StartShoakProcess.swift
//  Shoak
//
//  Created by 정종인 on 7/24/24.
//

import Foundation
import AppIntents

struct StartShoakProcess: AppIntent {
    static var title: LocalizedStringResource = "쇽! 보내기 시작하기"
    static var description: IntentDescription? = IntentDescription(stringLiteral: "쇽 보내기를 통해 친구를 불러보세요")
    static var openAppWhenRun: Bool = true
    static var authenticationPolicy: IntentAuthenticationPolicy = .requiresLocalDeviceAuthentication

    func perform() async throws -> some IntentResult {
        await navigationModel.setView(to: .friendList)
        return .result()
    }

    @Dependency
    private var navigationModel: NavigationModel

    @Dependency
    private var dataManager: ShoakDataManager
}
