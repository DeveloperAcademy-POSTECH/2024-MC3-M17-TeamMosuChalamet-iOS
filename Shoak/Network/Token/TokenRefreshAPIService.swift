//
//  TokenRefreshAPIService.swift
//  Shoak
//
//  Created by 정종인 on 7/29/24.
//

import Foundation
import Moya

final public class TokenRefreshAPIService {
    let provider = MoyaProvider<TokenRefreshAPI>()

    public init() {}

    func refresh(with refreshToken: RefreshToken) async -> Result<TokenPair, NetworkError> {
        let response = await provider.request(.refresh(refreshToken))
        switch response {
        case .success(let success):
            return NetworkHandler.requestDecoded(by: success)
        case .failure(let failure):
            print("cannot refresh token : \(failure)")
            return .failure(.networkFail)
        }
    }
}
