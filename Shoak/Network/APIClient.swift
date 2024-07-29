//
//  APIClient.swift
//  Shoak
//
//  Created by 정종인 on 7/27/24.
//

import Foundation
import Moya

public protocol APIClient {
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
        return createProvider(for: target)
    }
}

extension DefaultAPIClient {
    private func createProvider<Target: TargetType>(for target: Target.Type) -> MoyaProvider<Target> {
        let request = createRequest(for: target)
        return MoyaProvider<Target>(requestClosure: request, plugins: [StoreTokenPlugin(tokenManager: tokenManager), LoggerPlugin()])
    }

    private func createRequest<Target: TargetType>(for target: Target.Type) -> MoyaProvider<Target>.RequestClosure {
        let requestClosure = { [weak self] (endpoint: Endpoint, done: @escaping MoyaProvider.RequestResultClosure) in
            guard let request = try? endpoint.urlRequest() else {
                done(.failure(.requestMapping(endpoint.url)))
                return
            }

            guard self?.needToken(endpoint) == true else {
                done(.success(request)) // Authorization 헤더가 없으면 그냥 넘어간다.
                return
            }

            // 헤더에 Authorization 키가 있다면, 그 값을 채워준다.
            _Concurrency.Task.detached { [self] in
                guard let validResult = await self?.tokenManager.validTokenAndAddHeader(request: request) else {
                    return
                }

                switch validResult {
                case .success(let success):
                    done(.success(success))
                case .failure(let failure):
                    print("token validation failed : \(failure.localizedDescription)")
                    done(.failure(.requestMapping(endpoint.url)))
                }
            }
        }

        return requestClosure
    }

    private func needToken(_ endpoint: Endpoint) -> Bool {
        endpoint.httpHeaderFields?.keys.contains("Authorization") ?? false
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

/// 헤더에 토큰 설정을 추가하는 테스트 API Client
public final class AuthTestAPIClient: APIClient, TokenManagable {
    public var tokenManager = TokenManager(refreshAPIService: TokenRefreshAPIService(isTesting: true))

    public func resolve<Target: TargetType>(for target: Target.Type) -> MoyaProvider<Target> {
        let customEndpointClosure = { (target: Target) -> Endpoint in
            Endpoint(
                url: URL(target: target).absoluteString,
                sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                method: target.method,
                task: target.task,
                httpHeaderFields: target.headers
            )
        }
        return MoyaProvider<Target>(endpointClosure: customEndpointClosure, stubClosure: MoyaProvider.immediatelyStub, plugins: [LoggerPlugin(), StoreTokenPlugin(tokenManager: TokenManager(refreshAPIService: TokenRefreshAPIService(isTesting: true)))])
    }
}
