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
    static let shared = PhoneConnectivityManager()
    @ObservationIgnored var session: WCSession
    var message: String = "No message received"

    private init(session: WCSession = .default) {
        self.session = session
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
                self.message = receivedMessage
            }
        }
    }

    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async {
            print("receive user info : \(applicationContext)")
            if let receivedAccessToken = applicationContext["Access"] as? String, let receivedRefreshToken = applicationContext["Refresh"] as? String {
                self.message = receivedAccessToken
                TokenManager().save(AccessToken(receivedAccessToken))
                TokenManager().save(RefreshToken(receivedRefreshToken))
            }
        }
    }
}