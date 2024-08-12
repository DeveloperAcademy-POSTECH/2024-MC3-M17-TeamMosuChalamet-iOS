//
//  AcceptInvitationView.swift
//  Shoak
//
//  Created by 정종인 on 8/5/24.
//

import SwiftUI

struct AcceptInvitationView: View {
    @Environment(NavigationManager.self) private var navigationManager
    @Environment(InvitationManager.self) private var invitationManager
    @Environment(ShoakDataManager.self) private var shoakDataManager

    @State private var isLoading = false
    @State private var invitationFailed: String? = nil

    var body: some View {
        VStack(spacing: 32) {
            Text("초대를 수락하시겠습니까?")
            if let invitationFailed {
                Text("초대 수락에 실패했습니다. : \(invitationFailed)")
            }
            Button {
                isLoading = true
                Task {
                    if let invitation = navigationManager.invitation {
                        let response = await invitationManager.acceptInvitation(memberID: invitation)
                        switch response {
                        case .success:
                            print("초대 수락 성공!")
                            shoakDataManager.refreshFriends()
                            navigationManager.invitation = nil
                        case .failure(let error):
                            print("에러.. : \(error)")
                            withAnimation {
                                self.invitationFailed = error.localizedDescription
                            }
                        }
                    }
                    isLoading = false
                }
            } label: {
                if isLoading {
                    ProgressView()
                } else {
                    Text("초대 수락하기")
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(.shoakYellow)
        }
        .font(.textPageTitle)
    }
}
