//
//  InvitationUseCase.swift
//  Shoak
//
//  Created by KimYuBin on 7/30/24.
//

import Messages
import MessageUI

class InvitationUseCase: NSObject, MFMessageComposeViewControllerDelegate  {
    let invitationRepository: InvitationRepository

    init(invitationRepository: InvitationRepository) {
        self.invitationRepository = invitationRepository
    }

    // 초대 행위를 전달하기 (iMessage)
    func createMessageComposeViewController() -> MFMessageComposeViewController? {
        let messageComposeVC = MFMessageComposeViewController()
        let templateLayout = MSMessageTemplateLayout()
        //templateLayout.image = UIImage(systemName: "circle")
        templateLayout.caption = "앱스토어에서 Shoak을 다운로드해 주세요"
        let layout = MSMessageLiveLayout(alternateLayout: templateLayout)
        
        let message = MSMessage()
        message.layout = layout
        message.summaryText = "Shoak 친구 초대 메세지"
        
        messageComposeVC.message = message
        messageComposeVC.body = "친구 초대 메세지입니다."
        messageComposeVC.messageComposeDelegate = self
        
        return messageComposeVC
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }

    func acceptInvitation(memberID: TMMemberID) async -> Result<Void, Errors> {
        let result = await invitationRepository.acceptInvitation(memberID: memberID)
        switch result {
        case .success:
            print("초대 수락 완료!")
            return .success(())
        case .failure(let failure):
            print("초대 수락 실패 ㅠ")
            return .failure(.error(description: failure.localizedDescription))
        }
    }
}
