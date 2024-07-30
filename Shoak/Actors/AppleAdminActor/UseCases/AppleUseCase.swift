//
//  AppleUseCase.swift
//  Shoak
//
//  Created by KimYuBin on 7/25/24.
//

import Foundation
import SwiftUI
import AuthenticationServices
import Messages
import MessageUI

class AppleUseCase: NSObject, MFMessageComposeViewControllerDelegate  {
    
    // Sign in with Apple
    func handleSignInSuccess(authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            guard let token = appleIDCredential.identityToken,
                  let tokenString = String(data: token, encoding: .utf8)
            else {
                return
            }
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let name = (fullName?.familyName ?? "") + (fullName?.givenName ?? "")
            
            print("userID : \(userIdentifier)") // 유저ID는 항상 동일함
            print("name :  \(name)")
            print("token : \(tokenString)") // 토큰은 로그인 할때마다 달라짐.
        default:
            break
        }
    }
    
    func handleSignInFailure(error: Error) {
        print(error)
    }
    
    // 초대 행위를 전달하기 (iMessage)
    func createMessageComposeViewController() -> MFMessageComposeViewController? {
        let messageComposeVC = MFMessageComposeViewController()
        let templateLayout = MSMessageTemplateLayout()
        templateLayout.image = UIImage(systemName: "circle")
        templateLayout.caption = "캡션"
        let layout = MSMessageLiveLayout(alternateLayout: templateLayout)
        
        let message = MSMessage()
        message.layout = layout
        message.summaryText = "메세지 요약 텍스트"
        
        messageComposeVC.message = message
        messageComposeVC.body = "친구 초대 메세지입니다."
        messageComposeVC.messageComposeDelegate = self
        
        return messageComposeVC
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}
