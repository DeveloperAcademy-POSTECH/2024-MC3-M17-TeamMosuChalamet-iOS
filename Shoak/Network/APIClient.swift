//
//  APIClient.swift
//  Shoak
//
//  Created by 정종인 on 7/27/24.
//

import Foundation
import Moya

public protocol APIClient: Sendable {
    func resolve<Target: TargetType>(for target: Target.Type) -> MoyaProvider<Target>
}

public protocol TokenManagable {
    var tokenManager: TokenManager { get }
}

final public class DefaultAPIClient: APIClient, TokenManagable {
    public let tokenManager: TokenManager

    init(tokenManager: TokenManager) {
        self.tokenManager = tokenManager
    }

    public func resolve<Target: TargetType>(for target: Target.Type) -> MoyaProvider<Target> {
        return MoyaProvider<Target>(plugins: [
            ValidateAndAddTokenPlugin(tokenManager: tokenManager),
            TokenRefreshPlugin(tokenManager: tokenManager),
            StoreTokenPlugin(tokenManager: tokenManager),
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
