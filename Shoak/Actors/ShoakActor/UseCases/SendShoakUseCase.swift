//
//  SendShoakUseCase.swift
//  Shoak
//
//  Created by 정종인 on 7/24/24.
//

import Foundation

final class SendShoakUseCase {
    let shoakRepository: ShoakRepository

    init(shoakRepository: ShoakRepository) {
        self.shoakRepository = shoakRepository
    }

    func sendShoak(to receiverID: TMMemberID) async -> Result<Void, Errors> {
        let destination = receiverID
        let dto = TMShoakDestinationDTO(destinationMemberId: destination)
        let result = await shoakRepository.sendShoak(destination: dto)
        switch result {
        case .success:
            print("쇽 보내기 성공!")
            return .success(())
        case .failure(let failure):
            print("쇽 보내기 실패 ㅠ")
            return .failure(.error(description: failure.errorDescription))
        }
    }
}

// Sendable은 Intent에서 사용하기 위해 채택하였음.
extension SendShoakUseCase: Sendable {}
