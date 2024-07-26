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

    let friends: [TMProfileVO]

    private let accountUseCase: AccountUseCase

    private init() {
        self.friends = .mockData
        self.accountUseCase = AccountUseCase()
    }
}
