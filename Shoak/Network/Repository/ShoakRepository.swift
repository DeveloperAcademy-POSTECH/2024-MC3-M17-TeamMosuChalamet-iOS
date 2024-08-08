//
//  ShoakRepository.swift
//  Shoak
//
//  Created by 정종인 on 7/31/24.
//

import Foundation
import Moya

final class ShoakRepository {
    let apiClient: APIClient
    let provider: MoyaProvider<ShoakAPI>

    init(apiClient: APIClient) {
        self.apiClient = apiClient
        self.provider = apiClient.resolve(for: ShoakAPI.self)
    }

    func sendShoak(destination: TMMemberIDDTO) async -> Result<Void, NetworkError> {
        let response = await provider.request(.shoak(destination))
        switch response {
        case .success(let success):
            return NetworkHandler.requestPlain(by: success)
        case .failure(let failure):
            return .failure(.other(failure.localizedDescription))
        }
    }
}

// Sendable은 Intent에서 사용하기 위해 채택하였음.
extension ShoakRepository: Sendable {}
