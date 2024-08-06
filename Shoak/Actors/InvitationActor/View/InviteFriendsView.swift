//
//  InviteFriendsView.swift
//  Shoak
//
//  Created by KimYuBin on 7/30/24.
//

import SwiftUI
import MessageUI

struct InviteFriendsView: View {
    
    @State private var showMessageCompose = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @Environment(InvitationManager.self) private var invitationManager
    @Environment(AccountManager.self) private var accountManager
    @Environment(NavigationManager.self) private var navigationManager
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .center) {
                HStack {
                    BackButton {
                        navigationManager.setView(to: .friendList)
                    }
                    .frame(maxHeight: 44)
                    
                    Spacer()
                }
                
                Text("친구추가")
                    .font(.textPageTitle)
            }
            
            Spacer()
            
            VStack(spacing: 0) {
                MyProfileView()

                Button {
                    if MFMessageComposeViewController.canSendText() {
                        showMessageCompose = true
                    } else {
                        alertMessage = "이 장치는 문자 메시지를 보낼 수 없습니다."
                        showAlert = true
                    }
                } label: {
                    HStack(alignment: .center, spacing: 10) {
                        Image(systemName: "paperplane.fill")
                            .foregroundStyle(Color.textBlack)
                            .font(.icon)
                        
                        Text("공유하기")
                            .font(.textButton)
                            .foregroundStyle(Color.textBlack)
                    }
                    .padding(.horizontal, 41)
                    .padding(.vertical, 14)
                    .frame(width: 345, alignment: .center)
                    .background(Color.shoakYellow)
                    .cornerRadius(9)
                    .overlay(
                        RoundedRectangle(cornerRadius: 9)
                            .strokeBorder(Color.strokeBlack, lineWidth: 1)
                    )
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("에러"), message: Text(alertMessage), dismissButton: .default(Text("확인")))
                }
                .padding(.top, 6)
                
            }
            .padding(8)
            .background(Color.shoakWhite)
            .cornerRadius(17)
            .overlay(
                RoundedRectangle(cornerRadius: 17)
                    .strokeBorder(Color.strokeBlack, lineWidth: 1)
            )
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .onAppear {
            accountManager.refreshProfile()
        }
        .sheet(isPresented: $showMessageCompose) {
            if let profile = accountManager.profile {
                MessageComposeView(isPresented: $showMessageCompose, profile: profile)
            } else {
                Text("프로필을 불러올 수 없습니다. 다시 시도해주세요.")
            }
        }
    }
}

#Preview {
    InviteFriendsView()
        .addEnvironmentsForPreview()
}
