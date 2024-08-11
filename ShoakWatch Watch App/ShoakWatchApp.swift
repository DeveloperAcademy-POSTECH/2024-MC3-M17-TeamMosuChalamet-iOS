//
//  ShoakWatchApp.swift
//  ShoakWatch Watch App
//
//  Created by 정종인 on 7/25/24.
//

import SwiftUI
import WatchKit
import AppIntents
import UserNotifications

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    // 포그라운드 상태에서도 알림을 수신하기 위한 메서드
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
}

@main
struct ShoakWatch_Watch_AppApp: App {
    @Namespace var namespace
    private var shoakDataManager: ShoakDataManager
    private let phoneConnectivityManager: PhoneConnectivityManager
    private let notificationDelegate = NotificationDelegate()
    
    init() {
        
        
        let center = UNUserNotificationCenter.current()
        center.delegate = notificationDelegate
        Task {
            let options: UNAuthorizationOptions = [.alert, .sound, .badge]
            _ = try? await center.requestAuthorization(options: options)
            
        }

        let tokenRepository = KeychainTokenRepository()
        let tokenRefreshRepository = DefaultTokenRefreshRepository(tokenRepository: tokenRepository)

        let apiClient = DefaultAPIClient(tokenRepository: tokenRepository, tokenRefreshRepository: tokenRefreshRepository)

        let authRepository = AuthRepository(apiClient: apiClient)
        let shoakRepository = ShoakRepository(apiClient: apiClient)
        let userRepository = UserRepository(apiClient: apiClient)

        let appleUseCase = AppleUseCase()
        let authUseCase = AuthUseCase(authRepository: authRepository, tokenRepository: tokenRepository)
        let userUseCase = UserUseCase(userRepository: userRepository)
        let shoakUseCase = SendShoakUseCase(shoakRepository: shoakRepository)
        let tokenUseCase = TokenUseCase(tokenRepository: tokenRepository, tokenRefreshRepository: tokenRefreshRepository)

        let shoakDataManager = ShoakDataManager(userUseCase: userUseCase, shoakUseCase: shoakUseCase)

        let phoneConnectivityManager = PhoneConnectivityManager(tokenRepository: tokenRepository)

        self.shoakDataManager = shoakDataManager
        self.phoneConnectivityManager = phoneConnectivityManager
        
//        AppDependencyManager.shared.add(dependency: shoakDataManager)
//        AppDependencyManager.shared.add(dependency: navigationManager)
//        AppDependencyManager.shared.add(dependency: phoneConnectivityManager)
    }
    
    var body: some Scene {
        let navigationManager = NavigationManager(namespace: namespace)
        WindowGroup {
            ContentView()
                .environment(shoakDataManager)
                .environment(navigationManager)
                .environment(phoneConnectivityManager)
        }
        WKNotificationScene(controller: NotificationController.self, category: "shoakreceive")
    }
}
