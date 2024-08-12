//
//  ShoakDataManager.swift
//  Shoak
//
//  Created by 정종인 on 7/25/24.
//

import Foundation

@Observable
class ShoakDataManager: @unchecked Sendable {
    @ObservationIgnored private let userUseCase: UserUseCase
    @ObservationIgnored private let shoakUseCase: SendShoakUseCase

    var friends: [TMFriendVO]

    var isLoading: Bool = false

    init(userUseCase: UserUseCase, shoakUseCase: SendShoakUseCase) {
        self.userUseCase = userUseCase
        self.shoakUseCase = shoakUseCase
        self.friends = []
    }

    public func refreshFriends() {
        isLoading = true
        Task {
            await self.getFriends()
            self.isLoading = false
        }
    }

    private func getFriends() async {
        let result = await userUseCase.getFriends()
        switch result {
        case .success(let success):
            DispatchQueue.main.async {
                self.friends = success
            }
        case .failure(let failure):
            print("fail! : \(failure)")
            DispatchQueue.main.async {
                self.friends = []
            }
        }
    }

    public func sendShoak(to memberID: TMMemberID) async -> Result<Void, Errors> {
        return await shoakUseCase.sendShoak(to: memberID)
    }

    public func deleteFriend(memberID: TMMemberID) async -> Result<Void, Errors> {
        let result = await userUseCase.deleteFriend(memberID: memberID)
        switch result {
        case .success:
            print("친구 삭제 성공!")
            return .success(())
        case .failure(let failure):
            print("친구 삭제 실패 ㅠ")
            return .failure(.error(description: failure.localizedDescription))
        }
    }
}
