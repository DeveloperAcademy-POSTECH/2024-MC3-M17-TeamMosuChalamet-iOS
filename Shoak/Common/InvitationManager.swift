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

    private init() {
        self.inviteUseCase = InvitationUseCase(invitationRepository: InvitationRepository(apiClient: DefaultAPIClient(tokenManager: TokenManager.shared)))
    }

    func acceptInvitation(memberID: TMMemberID) async -> Result<Void, Errors> {
        return await self.inviteUseCase.acceptInvitation(memberID: memberID)
    }
}
