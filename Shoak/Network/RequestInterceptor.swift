//
//  RequestInterceptor.swift
//  Shoak
//
//  Created by 정종인 on 8/6/24.
//

import Foundation
import Moya
import Alamofire

// https://github.com/Alamofire/Alamofire/blob/master/Documentation/AdvancedUsage.md#adapting-and-retrying-requests-with-requestinterceptor

public final class DefaultRequestInterceptor: RequestInterceptor {
    public let tokenRepository: TokenRepository
    public let tokenRefreshRepository: TokenRefreshRepository
    init(tokenRepository: TokenRepository, tokenRefreshRepository: TokenRefreshRepository) {
        self.tokenRepository = tokenRepository
        self.tokenRefreshRepository = tokenRefreshRepository
    }
}

extension DefaultRequestInterceptor {
    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        completion(.success(urlRequest))
    }

    /// response가 왔을 때 401코드로 왔으면 토큰을 갱신한 후 retry를 한다.
    /// 갱신이 실패하면 retry를 하지 않는다.
    public func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        print("🥸🥸🥸🥸 Request Interceptor Retry")
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 401
        else {
            print("🥸🥸🥸🥸 Do Not Retry With Error: \(error.localizedDescription)")
            completion(.doNotRetryWithError(error))
            return
        }
        _Concurrency.Task.detached { [weak self] in
            if let accessToken = self?.tokenRepository.getAccessToken()?.token,
               let refreshToken = self?.tokenRepository.getRefreshToken()?.token {
                let result = await self?.tokenRefreshRepository.refreshAccessAndRefreshToken(accessToken, refreshToken: refreshToken)
                switch result {
                case .success:
                    print("🥸🥸🥸🥸 Refresh Success!")
                    completion(.retry)
                case .failure(let failure):
                    print("🥸🥸🥸🥸 Do Not Retry With Error : \(failure.localizedDescription)")
                    completion(.doNotRetryWithError(failure))
                case .none:
                    print("🥸🥸🥸🥸 Do Not Retry")
                    completion(.doNotRetry)
                }
            }
        }
    }
}
