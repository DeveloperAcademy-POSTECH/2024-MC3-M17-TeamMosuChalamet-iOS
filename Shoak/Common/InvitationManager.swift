//
//  InvitationManager.swift
//  Shoak
//
//  Created by KimYuBin on 7/30/24.
//

import Foundation

@Observable
class InvitationManager: @unchecked Sendable {
    @ObservationIgnored let invitationUseCase: InvitationUseCase

    init(invitationUseCase: InvitationUseCase) {
        self.invitationUseCase = invitationUseCase
    }

    func acceptInvitation(memberID: TMMemberID) async -> Result<Void, Errors> {
        return await self.invitationUseCase.acceptInvitation(memberID: memberID)
    }
}
