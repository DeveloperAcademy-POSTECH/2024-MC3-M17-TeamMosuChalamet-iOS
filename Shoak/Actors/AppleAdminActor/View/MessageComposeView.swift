//
//  MessageComposeView.swift
//  Shoak
//
//  Created by KimYuBin on 7/28/24.
//

import SwiftUI
import MessageUI
import Messages

struct MessageComposeView: UIViewControllerRepresentable {
    @Environment(InvitationManager.self) private var invitationManager
    @Environment(AccountManager.self) private var accountManager
    @Binding var isPresented: Bool
    var profile: TMProfileVO

    func makeCoordinator() -> Coordinator {
        Coordinator(isPresented: $isPresented)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let messageComposeVC = MFMessageComposeViewController()
        let templateLayout = MSMessageTemplateLayout()
        templateLayout.image = UIImage(named: "ShoakLogoFilled")

        let memberID = "\(profile.id)"
        let name = "\(profile.name)"
        let imageURL = profile.imageURL

        var components = URLComponents()
        components.scheme = "https"
        components.host = "invite"
        components.path = "/"
        let idItem = URLQueryItem(name: "memberID", value: memberID)
        let nameItem = URLQueryItem(name: "name", value: name)
        let imageItem = URLQueryItem(name: "imageURL", value: imageURL)
        components.queryItems = [idItem, nameItem, imageItem]

        let message = MSMessage()
        message.layout = templateLayout
        message.url = components.url
        message.summaryText = "쇽 초대!"

        messageComposeVC.message = message
        messageComposeVC.messageComposeDelegate = context.coordinator
        messageComposeVC.body = "Shoak 앱을 다운로드 해주세요!"
        return messageComposeVC
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Do nothing here
    }

    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        @Binding var isPresented: Bool

        init(isPresented: Binding<Bool>) {
            _isPresented = isPresented
        }

        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            controller.dismiss(animated: true) {
                self.isPresented = false
            }
        }
    }
}
