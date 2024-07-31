//
//  TokenRefreshPlugin.swift
//  Shoak
//
//  Created by 정종인 on 7/31/24.
//

import Foundation
import Moya

/// 자동으로 토큰을 refresh해주고 재요청까지 보내는 플러그인
final class TokenRefreshPlugin: PluginType {
    let tokenManager: TokenManager
    private var pendingRequest: (request: URLRequest, target: TargetType)?
    init(tokenManager: TokenManager) {
        self.tokenManager = tokenManager
    }
    func didReceive(_ result: Result<Response, MoyaError>, target: any TargetType) async {
        switch result {
        case .success(let success):
            await onSuccess(success, target: target)
        case .failure(let failure):
            if let response = failure.response {
                await onSuccess(response, target: target)
            }
        }
    }

    private func onSuccess(_ response: Response, target: TargetType) async {
        let request = response.request
        let url = request?.url?.absoluteString ?? "nil"
        let statusCode = response.statusCode

        var log = "------------------- 네트워크 통신 성공 -------------------"
        log.append("\n[\(statusCode)] \(url)\n----------------------------------------------------\n")
        log.append("API: \(target)\n")
        response.response?.allHeaderFields.forEach {
            log.append("\($0): \($1)\n")
        }
        if let reString = String(bytes: response.data, encoding: String.Encoding.utf8) {
            log.append("\(reString)\n")
        }
        log.append("------------------- END HTTP (\(response.data.count)-byte body) -------------------")
        print(log)

        // 🔥 401 인 경우 리프레쉬 토큰 + 액세스 토큰 을 가지고 갱신 시도.
        switch statusCode {
        case 401:
            guard let identityToken = tokenManager.getIdentityToken(),
                  let deviceToken = tokenManager.getDeviceToken(),
                  let originalRequest = response.request
            else {
                return
            }
            let name = AccountManager.shared.profile?.name ?? "" // TODO: 조금 더 좋은 방향이 있을 것 같은데..
            pendingRequest = (request: originalRequest, target: target)
            let reissueResult = await tokenReissueWithAPI(requestDTO: TMTokenRefreshRequestDTO(identityToken: identityToken.token, name: name, deviceToken: deviceToken.token))
            switch reissueResult {
            case .success:
                print("reissue success!")
                // 실패했던 요청 다시 보내기!
                await retryPendingRequest()

            case .failure(let failure):
                print("reissue failed : \(failure.localizedDescription)")
                tokenManager.deleteAllTokensWithoutDeviceToken()
            }
        default:
            return
        }
    }

    private func retryPendingRequest() async {
        guard let (request, target) = pendingRequest else { return }
        // Assuming you have a Moya provider instance available
        let provider = MoyaProvider<MultiTarget>()
        let targetType = MultiTarget(target)

        let result = await provider.request(targetType)
        switch result {
        case .success(let response):
            print("Retry request success: \(response)")
        case .failure(let error):
            print("Retry request failed: \(error.localizedDescription)")
        }
        pendingRequest = nil
    }
}

// 🔥 Network
extension TokenRefreshPlugin {
    /// requestDTO를 활용해서 토큰 refresh를 시도함. 성공하면 Void, 실패하면 Void
    func tokenReissueWithAPI(requestDTO: TMTokenRefreshRequestDTO) async -> Result<Void, TokenError> {
        let apiClient = DefaultAPIClient(tokenManager: tokenManager)
        let provider = apiClient.resolve(for: TokenRefreshAPI.self)
        let result = await provider.request(.refresh(requestDTO))
        switch result {
        case .success(let success):
            if 200..<300 ~= success.statusCode {
                return .success(())
            } else {
                return .failure(.cannotRefresh)
            }
        case .failure(let error):
            print("token refresh error : \(error.localizedDescription)")
            return .failure(.cannotRefresh)
        }
    }
}
