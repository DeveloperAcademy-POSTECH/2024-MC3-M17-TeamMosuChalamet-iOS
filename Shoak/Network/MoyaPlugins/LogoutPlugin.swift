//
//  LogoutPlugin.swift
//  Shoak
//
//  Created by chongin on 8/16/24.
//

import Foundation
import Moya
#if os(iOS)
import UIKit
#endif

struct LogoutPlugin: PluginType {
    private let tokenRepository: TokenRepository
    init(tokenRepository: TokenRepository) {
        self.tokenRepository = tokenRepository
    }
    func didReceive(_ result: Result<Response, MoyaError>, target: any TargetType) {
        if case .failure(let failure) = result {
            if failure.response?.statusCode == 401 || failure.response?.statusCode == 403 {
                tokenRepository.deleteAllTokens()
#if os(iOS)
                UIApplication.shared.unregisterForRemoteNotifications()
#endif
                NotificationCenter.default.post(name: .toLoginView, object: nil)
            }
        }
    }
}
