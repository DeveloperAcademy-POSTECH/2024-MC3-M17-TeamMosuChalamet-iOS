//
//  ShoakAppDelegate.swift
//  Shoak
//
//  Created by 정종인 on 7/30/24.
//

import Foundation
import UIKit

class ShoakAppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    let tokenUseCase: TokenUseCase
    override init() {
        let tokenRepository = KeychainTokenRepository()
        let tokenRefreshRepository = DefaultTokenRefreshRepository(tokenRepository: tokenRepository)
        self.tokenUseCase = TokenUseCase(tokenRepository: tokenRepository, tokenRefreshRepository: tokenRefreshRepository)
        super.init()
    }
    /// 앱이 시작되면 APNs 서버에 디바이스 토큰을 달라고 요청한다.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in

            if let error = error {
                // Handle the error here.
                print(error)
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
        Task {
            await tokenUseCase.registerDeviceToken(deviceToken: token)
        }
    }

    /// APNs 서버 연결에 실패하면 에러를 뱉는다.
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("register remote notification error:\(error)")
        // Try again later.
    }

    /// In-App에서도 알람이 오게끔!
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
}
