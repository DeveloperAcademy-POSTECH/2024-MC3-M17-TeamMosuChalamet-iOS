//
//  UserRepository.swift
//  Shoak
//
//  Created by 정종인 on 7/27/24.
//

import Foundation
import Moya

final class UserRepository {
    let provider: MoyaProvider<UserAPI>

    init(apiClient: APIClient) {
        self.provider = apiClient.resolve(for: UserAPI.self)
    }

    func getProfile() async -> Result<TMProfileDTO, NetworkError> {
        let response = await provider.request(.getProfile)
        switch response {
        case .success(let success):
            return NetworkHandler.requestDecoded(by: success)
        case .failure(let failure):
            return .failure(.other(failure.localizedDescription))
        }
    }

    func getFriends() async -> Result<[TMFriendDTO], NetworkError> {
        let response = await provider.request(.getFriends)
        switch response {
        case .success(let success):
            return NetworkHandler.requestDecoded(by: success)
        case .failure(let failure):
            return .failure(.other(failure.localizedDescription))
        }
    }

    func uploadProfileImage(data: Data) async -> Result<TMProfileDTO, NetworkError> {
        let response = await provider.request(.uploadProfileImage(data: data))
        switch response {
        case .success(let success):
            return NetworkHandler.requestDecoded(by: success)
        case .failure(let failure):
            return .failure(.other(failure.localizedDescription))
        }
    }

    func deleteFriend(memberID: TMMemberID) async -> Result<Void, NetworkError> {
        let response = await provider.request(.deleteFriend(memberID: TMMemberIDDTO(id: memberID)))
        switch response {
        case .success(let success):
            return NetworkHandler.requestPlain(by: success)
        case .failure(let failure):
            return .failure(.other(failure.localizedDescription))
        }
    }
}
