//
//  WatchNotificationController.swift
//  ShoakWatch Watch App
//
//  Created by yeji on 7/31/24.
//

import SwiftUI
import UserNotifications
import WatchKit

// WatchKit에서 알림을 위한 뷰 컨트롤러
class NotificationController: WKUserNotificationHostingController<WatchNotificationView> {
    
    var profile: TMProfileVO?
    var message: String?
    
    // 알림을 처리하고 SwiftUI 뷰를 구성하는 메서드
    override var body: WatchNotificationView {
        WatchNotificationView(message: message, profile: profile)
    }
    
    override func didReceive(_ notification: UNNotification) {
        let notificationData = notification.request.content.userInfo
        
        // 'message'와 'profileImageURL' 추출
        message = notificationData["message"] as? String
        
              if let profileImageURL = notificationData["profileImageURL"] as? String,
                 let profileName = notificationData["profileName"] as? String {
                  profile = TMProfileVO(name: profileName, imageURL: profileImageURL)
              }
        
        // 선택적으로 Haptic 피드백을 추가할 수 있습니다.
        HapticFeedback()
    }
    
    private func HapticFeedback() {
        for _ in 0..<3 {
                   WKInterfaceDevice.current().play(.notification)
             
            Thread.sleep(forTimeInterval: 0.1)
               }
           }
       }

