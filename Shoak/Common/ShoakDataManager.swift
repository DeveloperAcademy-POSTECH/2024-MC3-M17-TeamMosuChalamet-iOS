//
//  ShoakDataManager.swift
//  Shoak
//
//  Created by 정종인 on 7/25/24.
//

import Foundation

@Observable
class ShoakDataManager: @unchecked Sendable {
    static let shared = ShoakDataManager()

    private let userUseCase: UserUseCase

    var friends: [TMProfileVO]

    private init() {
        self.friends = .mockData
        let apiClient = DefaultAPIClient()
        let userRepository = UserRepository(apiClient: apiClient)
        self.userUseCase = UserUseCase(userRepository: userRepository)
        refreshFriends()
    }

    public func refreshFriends() {
        Task {
            await getFriends()
        }
    }

    public func getFriends() async {
        let result = await userUseCase.getFriends()
        switch result {
        case .success(let success):
            self.friends = success
        case .failure(let failure):
            print("fail! : \(failure)")
        }
    }
}
