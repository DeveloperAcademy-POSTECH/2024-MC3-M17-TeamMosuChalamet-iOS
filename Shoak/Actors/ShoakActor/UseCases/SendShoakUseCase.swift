//
//  SendShoakUseCase.swift
//  Shoak
//
//  Created by 정종인 on 7/24/24.
//

import Foundation

final class SendShoakUseCase {
    func sendShoak(from senderID: TMMemberID, to receiverID: TMMemberID, with message: String?) -> Result<Void, Errors> {
        return .success(())
    }
}

// Sendable은 Intent에서 사용하기 위해 채택하였음.
extension SendShoakUseCase: Sendable {}
