//
//  ShoakAppDelegate.swift
//  Shoak
//
//  Created by 정종인 on 7/30/24.
//

import Foundation
import UIKit

class ShoakAppDelegate: NSObject, UIApplicationDelegate {
    /// 앱이 시작되면 APNs 서버에 디바이스 토큰을 달라고 요청한다.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in

            if let error = error {
                // Handle the error here.
            }

            // Enable or disable features based on the authorization.
        }
        UIApplication.shared.registerForRemoteNotifications()

        return true
    }
    /// APNs 서버에 연결되면 디바이스 토큰을 추출한다.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token: String = ""
        for i in 0..<deviceToken.count {
            token += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
        }
        print("APNs token: \(token)")
    }

    /// APNs 서버 연결에 실패하면 에러를 뱉는다.
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("register remote notification error:\(error)")
        // Try again later.
    }
}
