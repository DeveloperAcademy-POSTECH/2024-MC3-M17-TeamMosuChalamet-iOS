//
//  PhoneConnectivityManager.swift
//  ShoakWatch Watch App
//
//  Created by 정종인 on 8/1/24.
//

import Foundation
import WatchConnectivity

@Observable
class PhoneConnectivityManager: NSObject, WCSessionDelegate {
    @ObservationIgnored var session: WCSession
    let tokenRepository: TokenRepository
    var needToRefresh: Bool = false

    init(session: WCSession = .default, tokenRepository: TokenRepository) {
        self.session = session
        self.tokenRepository = tokenRepository
        super.init()
        self.session.delegate = self
        session.activate()
    }

    // WCSessionDelegate Methods
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Handle activation state
    }

    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        DispatchQueue.main.async {
            print("receive user info : \(userInfo)")
            if let receivedMessage = userInfo["Access"] as? String {
                print("receivedMessage: \(receivedMessage)")
            }
        }
    }

    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async { [self] in
            print("receive user info : \(applicationContext)")
            let receivedAccessToken = applicationContext["Access"] as? String
            let receivedRefreshToken = applicationContext["Refresh"] as? String
            let receivedIdentityToken = applicationContext["Identity"] as? String
            let receivedDeviceToken = applicationContext["Device"] as? String

            if let accessTokenString = receivedAccessToken, !accessTokenString.isEmpty {
                self.tokenRepository.save(accessToken: AccessToken(accessTokenString))
            } else {
                self.tokenRepository.save(accessToken: nil)
            }
            if let refreshTokenString = receivedRefreshToken, !refreshTokenString.isEmpty {
                self.tokenRepository.save(refreshToken: RefreshToken(refreshTokenString))
            } else {
                self.tokenRepository.save(refreshToken: nil)
            }
            if let identityTokenString = receivedIdentityToken, !identityTokenString.isEmpty {
                self.tokenRepository.save(identityToken: IdentityToken(identityTokenString))
            } else {
                self.tokenRepository.save(identityToken: nil)
            }
            if let deviceTokenString = receivedDeviceToken, !deviceTokenString.isEmpty {
                self.tokenRepository.save(deviceToken: DeviceToken(deviceTokenString))
            } else {
                self.tokenRepository.save(deviceToken: nil)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.needToRefresh = true
            }
        }
    }
}
