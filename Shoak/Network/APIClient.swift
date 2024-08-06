//
//  APIClient.swift
//  Shoak
//
//  Created by 정종인 on 7/27/24.
//

import Foundation
import Moya
import Alamofire


public protocol APIClient: Sendable {
    func resolve<Target: TargetType>(for target: Target.Type) -> MoyaProvider<Target>
}

public final class TokenRefreshAPIClient: APIClient, @unchecked Sendable {
    private let tokenRepository: TokenRepository
    private let tokenRefreshRepository: TokenRefreshRepository
    init(tokenRepository: TokenRepository, tokenRefreshRepository: TokenRefreshRepository) {
        self.tokenRepository = tokenRepository
        self.tokenRefreshRepository = tokenRefreshRepository
    }

    public func resolve<Target>(for target: Target.Type) -> MoyaProvider<Target> where Target : TargetType {
        return MoyaProvider<Target>(plugins: [
            AddTokenPlugin(tokenRepository: tokenRepository),
            StoreTokenPlugin(tokenRepository: tokenRepository),
            NetworkLoggerPlugin(),
            LoggerPlugin()
        ])
    }
}

public final class DefaultAPIClient: APIClient, @unchecked Sendable {
    private let tokenRepository: TokenRepository
    private let tokenRefreshRepository: TokenRefreshRepository

    init(tokenRepository: TokenRepository, tokenRefreshRepository: TokenRefreshRepository) {
        self.tokenRepository = tokenRepository
        self.tokenRefreshRepository = tokenRefreshRepository
    }

    public func resolve<Target: TargetType>(for target: Target.Type) -> MoyaProvider<Target> {
        let interceptor = DefaultRequestInterceptor(tokenRepository: tokenRepository, tokenRefreshRepository: tokenRefreshRepository)
        let session = Session(interceptor: interceptor)
        return MoyaProvider<Target>(session: session, plugins: [
            AddTokenPlugin(tokenRepository: tokenRepository),
//            TokenRefreshPlugin(tokenManager: tokenManager),
            StoreTokenPlugin(tokenRepository: tokenRepository),
            NetworkLoggerPlugin(),
            LoggerPlugin()
        ])
    }
}

public final class TestAPIClient: APIClient {
    public func resolve<Target: TargetType>(for target: Target.Type) -> MoyaProvider<Target> {
        let customEndpointClosure = { (target: Target) -> Endpoint in
            Endpoint(
                url: URL(target: target).absoluteString,
                sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                method: .get,
                task: target.task,
                httpHeaderFields: target.headers
            )
        }
        return MoyaProvider<Target>(endpointClosure: customEndpointClosure, stubClosure: MoyaProvider.immediatelyStub, plugins: [LoggerPlugin()])
    }
}
