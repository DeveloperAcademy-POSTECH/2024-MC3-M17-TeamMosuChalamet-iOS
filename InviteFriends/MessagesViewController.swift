//
//  MessagesViewController.swift
//  InviteFriends
//
//  Created by KimYuBin on 7/28/24.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    
    @IBAction func refuseButtonDidTap(_ sender: Any) {
        print("거절")
    }
    
    @IBAction func acceptButtonDidTap(_ sender: Any) {
        print("수락")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        // iMessage 확장이 활성화될 때 실행될 코드
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // iMessage 확장이 비활성화될 때 실행될 코드
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // 다른 기기에서 생성된 메시지를 받을 때 실행될 코드
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // 사용자가 전송 버튼을 탭할 때 실행될 코드
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // 사용자가 메시지를 전송하지 않고 삭제할 때 실행될 코드
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // 확장이 새로운 프레젠테이션 스타일로 전환되기 전에 실행될 코드
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // 확장이 새로운 프레젠테이션 스타일로 전환된 후에 실행될 코드
    }
}
