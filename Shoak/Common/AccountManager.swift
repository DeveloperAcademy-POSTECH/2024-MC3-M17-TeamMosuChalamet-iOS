//
//  AccountManager.swift
//  Shoak
//
//  Created by 정종인 on 7/27/24.
//

import Foundation

@Observable
class AccountManager: @unchecked Sendable {
    static let shared = AccountManager()

    @ObservationIgnored private let accountUseCase: AccountUseCase

    private init() {
        self.accountUseCase = AccountUseCase()
    }
}

// MARK: - Computed Properties
extension AccountManager {
    var isLoggedIn: Bool {
        accountUseCase.isLoggedIn()
    }
}
