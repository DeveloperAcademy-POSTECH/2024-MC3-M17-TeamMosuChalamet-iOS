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

final public class DefaultAPIClient: APIClient {
    public func resolve<Target: TargetType>(for target: Target.Type) -> MoyaProvider<Target> {
        return createProvider(for: target)
    }
}

extension DefaultAPIClient {
    private func createProvider<Target: TargetType>(for target: Target.Type) -> MoyaProvider<Target> {
        let request = createRequest(for: target)
        return MoyaProvider<Target>(requestClosure: request, plugins: []) // TODO: Logger 추가하기
    }

    private func createRequest<Target: TargetType>(for target: Target.Type) -> MoyaProvider<Target>.RequestClosure {
        let requestClosure = { [weak self] (endpoint: Endpoint, done: @escaping MoyaProvider.RequestResultClosure) in
            guard let request = try? endpoint.urlRequest() else {
                done(.failure(.requestMapping(endpoint.url)))
                return
            }

            done(.success(request))

            // TODO: Token Logic 추가
        }

        return requestClosure
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
        return MoyaProvider<Target>(endpointClosure: customEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)
    }
}
