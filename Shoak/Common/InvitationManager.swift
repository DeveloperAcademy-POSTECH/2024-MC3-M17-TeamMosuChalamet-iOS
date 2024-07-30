//
//  InvitationManager.swift
//  Shoak
//
//  Created by KimYuBin on 7/30/24.
//

import Foundation

@Observable
class InvitationManager: @unchecked Sendable {
    static let shared = InvitationManager()
    
    let inviteUseCase: InvitationUseCase

    init() {
        self.inviteUseCase = InvitationUseCase()
    }
}
