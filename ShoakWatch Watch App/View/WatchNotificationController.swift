//
//  WatchNotificationController.swift
//  ShoakWatch Watch App
//
//  Created by yeji on 7/31/24.
//

import SwiftUI
import WatchKit
import UserNotifications


class WatchNotificationController: WKUserNotificationHostingController<WatchNotificationView> {
    
    var profile: TMProfileVO?
    var message: String?
    
    let profileNameKey = "profileName"
    let profileImageURLKey = "profileImageURL"
    
    override var body: WatchNotificationView {
        WatchNotificationView( message: message,
                               profile: profile)
    }
    
  
       
    override func didReceive(_ notification: UNNotification) {
        
                HapticFeedback()
        
        let notificationData = notification.request.content.userInfo as? [String: Any]
        
        let aps = notificationData?["aps"] as? [String: Any]
        let alert = aps?["alert"] as? [String: Any]
        
        message = notificationData?["message"] as? String
        
        if let profileName = notificationData?[profileNameKey] as? String,
           let profileImageURL = notificationData?[profileImageURLKey] as? String {
            profile = TMProfileVO(name: profileName, imageURL: profileImageURL)
        }
        
    }
        private func HapticFeedback() {
            
            WKInterfaceDevice.current().play(.notification)
            
        }
}

