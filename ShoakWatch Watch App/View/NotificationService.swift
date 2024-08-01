//
//  NotificationService.swift
//  ShoakWatch Watch App
//
//  Created by yeji on 8/1/24.
//

import UserNotifications
import UserNotificationsUI

class NotificationService: UNNotificationServiceExtension {
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

        guard let bestAttemptContent = bestAttemptContent else {
            return
        }

        // `profileImageURL`을 사용하여 이미지 URL을 가져옵니다.
        if let imageUrlString = bestAttemptContent.userInfo["profileImageURL"] as? String,
           let fileUrl = URL(string: imageUrlString) {
            URLSession.shared.downloadTask(with: fileUrl) { location, response, error in
                if let location = location {
                    do {
                        let attachment = try UNNotificationAttachment(identifier: "", url: location, options: nil)
                        bestAttemptContent.attachments = [attachment]
                    } catch {
                        print("Attachment Error: \(error)")
                    }
                }
                contentHandler(bestAttemptContent)
            }.resume()
        } else {
            contentHandler(bestAttemptContent)
        }
    }

    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}
