//
//  ShoakIntents.swift
//  Shoak
//
//  Created by 정종인 on 7/24/24.
//

import Foundation
import AppIntents

struct SendShoakIntent: AppIntent {
    static var title: LocalizedStringResource = "쇽! 보내기"
    static var description: IntentDescription? = IntentDescription(stringLiteral: "선택한 친구에게 쇽! 메세지를 보낼 수 있어요.")
    static var openAppWhenRun: Bool = false
    static var authenticationPolicy: IntentAuthenticationPolicy = .alwaysAllowed

    private let sendShoakUseCase: SendShoakUseCase = SendShoakUseCase()
    private let accountUseCase: AccountUseCase = AccountUseCase()

    @Parameter(title: "상대방 ID")
    var targetID: TMMemberID

    func perform() async throws -> some IntentResult & ProvidesDialog {
        guard let myID = accountUseCase.getMyMemberID() else {
            return .result(dialog: "MemberID를 가져올 수 없어요.") // TODO: 자신의 memberID를 가져올 수 없을 때
        }

        let sendResult = sendShoakUseCase.sendShoak(from: myID, to: targetID, with: nil)

        switch sendResult {
        case .success(let success):
            return .result(dialog: "쇽 보내기 성공!") // TODO: 쇽 보내기 성공했을 때
        case .failure(let failure):
            return .result(dialog: "쇽 보내기 실패..") // TODO: 쇽 보내기 실패했을 때
        }
    }
}
