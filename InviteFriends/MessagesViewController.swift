//
//  MessagesViewController.swift
//  InviteFriends
//
//  Created by KimYuBin on 7/28/24.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {

    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        super.willBecomeActive(with: conversation)

        presentViewController(for: conversation, with: presentationStyle)

        // 현재 사용자가 받은 사람일 때만 버튼을 표시
//        if let senderId = conversation.selectedMessage?.senderParticipantIdentifier,
//           senderId != conversation.localParticipantIdentifier {
//            acceptButton.isHidden = false
//            self.messageURL = conversation.selectedMessage?.url
//            self.messageURL = conversation.
//            print("selfmessageURL: \(self.messageURL)")
//        } else {
//            acceptButton.isHidden = true
//        }
    }
    
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        super.didReceive(message, conversation: conversation)
        // 메시지를 받은 경우의 추가 처리
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        super.didStartSending(message, conversation: conversation)
        // 메시지 전송 중 추가 처리
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        super.didCancelSending(message, conversation: conversation)
        // 메시지 전송 취소 시 추가 처리
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        super.willTransition(to: presentationStyle)
        // 프레젠테이션 스타일 변경 전 처리

        removeAllChildViewControllers()

        // 전체 화면으로 전환되는 것을 방지
        if presentationStyle == .expanded {
            self.requestPresentationStyle(.compact)
        }
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        super.didTransition(to: presentationStyle)
        // 프레젠테이션 스타일 변경 후 처리

        guard let conversation = activeConversation else { return }
        presentViewController(for: conversation, with: presentationStyle)
    }

    private func presentViewController(for conversation: MSConversation, with presentationStyle: MSMessagesAppPresentationStyle) {
        removeAllChildViewControllers()

        guard let messageURL = conversation.selectedMessage?.url?.absoluteString,
              let component = URLComponents(string: messageURL),
        let memberID = component.queryItems?.first(where: { $0.name == "memberID" })?.value?.toInt64(),
        let name = component.queryItems?.first(where: { $0.name == "name" })?.value else {
            return
        }

        let imageURL = component.queryItems?.first(where: { $0.name == "imageURL" })?.value

        let controller: UIViewController
        controller = instantiateInvitationViewController(with: TMProfileVO(id: memberID, name: name, imageURL: imageURL))

        addChild(controller)
        controller.view.frame = view.bounds
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)

        NSLayoutConstraint.activate([
            controller.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            controller.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            controller.view.topAnchor.constraint(equalTo: view.topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        controller.didMove(toParent: self)
    }

    private func instantiateInvitationViewController(with profile: TMProfileVO) -> InvitationViewController {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "InvitationViewController") as? InvitationViewController else {
            fatalError("Unable to instantiate and InvitationViewController from the storyboard")
        }

        controller.messageURL = URL(string: "shoak://invite/?memberID=\(profile.id)")
        controller.profile = profile

        return controller
    }

    private func removeAllChildViewControllers() {
        for child in children {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
}
