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

    @State private var isLoading = false

    var body: some View {
        VStack(spacing: 32) {
            Text("초대를 수락하시겠습니까?")
            Button {
                isLoading = true
                Task {
                    if let invitation = navigationManager.invitation {
                        let response = await invitationManager.acceptInvitation(memberID: invitation)
                        switch response {
                        case .success:
                            print("초대 수락 성공!")
                            navigationManager.invitation = nil
                        case .failure(let error):
                            print("에러.. : \(error)")
                        }
                    }
                    isLoading = false
                }
                print("초대 수락!!!!!!!!!")
                navigationManager.invitation = nil
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
