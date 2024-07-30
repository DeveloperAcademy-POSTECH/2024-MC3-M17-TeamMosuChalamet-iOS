//
//  TokenRefreshAPIService.swift
//  Shoak
//
//  Created by 정종인 on 7/29/24.
//

import Foundation
import Moya

final public class TokenRefreshAPIService {
    let provider: MoyaProvider<TokenRefreshAPI>

    public init(isTesting: Bool = false) {
        if isTesting {
            provider = TokenRefreshAPIService.testingProvider()
        } else {
            provider = MoyaProvider<TokenRefreshAPI>()
        }
    }

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

    private static func testingProvider() -> MoyaProvider<TokenRefreshAPI> {
        let customEndpointClosure = { (target: TokenRefreshAPI) -> Endpoint in
            Endpoint(
                url: URL(target: target).absoluteString,
                sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                method: .get,
                task: target.task,
                httpHeaderFields: target.headers
            )
        }
        return MoyaProvider<TokenRefreshAPI>(endpointClosure: customEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)
    }
}
