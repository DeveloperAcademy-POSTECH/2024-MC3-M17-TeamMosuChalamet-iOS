//
//  WatchConnectivityManager.swift
//  Shoak
//
//  Created by 정종인 on 8/1/24.
//

import Foundation
import WatchConnectivity

@Observable
final class WatchConnectivityManager: NSObject, WCSessionDelegate {
    static let shared = WatchConnectivityManager()
    @ObservationIgnored var session: WCSession

    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
    }

    /// sendUserInfo : 비동기적으로 데이터를 전송하며, 데이터가 전달된 순서대로 순차적으로 수신됩니다.
//    func sendUserInfo(data: [String: Any]) {
//        WCSession.default.transferUserInfo(data)
//    }

    /// 앱의 현재 상태를 나타내는 데이터를 전송합니다. 이 메서드는 단일 상태를 전송하며, 이전 상태는 새로운 상태로 덮어쓰여집니다.
    /// Apple Watch가 연결되어 있지 않을 때 전송된 데이터는 나중에 연결되었을 때 수신됩니다. 하지만 여러 번 상태가 업데이트되면 가장 최근에 업데이트된 상태만 유효하며 이전 상태는 무시됩니다.
//    func updateApplicationContext(data: [String: Any]) {
//        do {
//            try WCSession.default.updateApplicationContext(data)
//            print("Update application context: \(data)")
//        } catch {
//            print("Failed to update application context: \(error.localizedDescription)")
//        }
//    }

    // WCSessionDelegate Methods
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Handle activation state
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        // Handle session becoming inactive
    }

    func sessionDidDeactivate(_ session: WCSession) {
        // Handle session deactivation
        WCSession.default.activate()
    }

    func sendMessage(data: [String: Any]) {
        do {
            print("send message : \(data)")
            try self.session.updateApplicationContext(data)
        } catch {
            print("error! : \(error.localizedDescription)")
        }
    }
}
