//
//  InvitationRepository.swift
//  Shoak
//
//  Created by 정종인 on 8/5/24.
//

import Foundation
import Moya

final class InvitationRepository {
    let apiClient: APIClient
    let provider: MoyaProvider<InvitationAPI>

    init(apiClient: APIClient) {
        self.apiClient = apiClient
        self.provider = apiClient.resolve(for: InvitationAPI.self)
    }

    func acceptInvitation(memberID: TMMemberID) async -> Result<Void, NetworkError> {
        let response = await provider.request(.acceptInvitation(TMMemberIDDTO(id: memberID)))
        switch response {
        case .success:
            return .success(())
        case .failure(let failure):
            return .failure(.other(failure.localizedDescription))
        }
    }
}
