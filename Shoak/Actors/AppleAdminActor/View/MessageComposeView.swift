//
//  MessageComposeView.swift
//  Shoak
//
//  Created by KimYuBin on 7/28/24.
//

import SwiftUI
import MessageUI

struct MessageComposeView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    let useCase: InvitationUseCase

    func makeCoordinator() -> Coordinator {
        Coordinator(isPresented: $isPresented)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        guard let messageComposeVC = useCase.createMessageComposeViewController() else {
            context.coordinator.isPresented = false
            let alertController = UIAlertController(title: "에러", message: "이 장치는 문자 메시지를 보낼 수 없습니다.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "확인", style: .default))
            return alertController
        }
        messageComposeVC.messageComposeDelegate = context.coordinator
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
