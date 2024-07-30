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
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0){
                Image(systemName: "person.circle.fill")
                    .font(.Icon)
                
                Text("내 프로필")
                    .font(.TextBody)
                    .foregroundStyle(Color.TextBlack)
                    .padding(.leading, 6)
                
                Spacer()
            }
            .padding(10)
            
            Divider()
                .padding(.vertical, 6)
            
            VStack(alignment: .center, spacing: 21) {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 80, height: 80)
                    .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                    .cornerRadius(30)
                
                Text("이름 테스트")
                    .font(.TextTitle)
                    .foregroundStyle(Color.TextBlack)
            }
            .padding(7)
            
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
                        .foregroundStyle(Color.TextBlack)
                        .font(.Icon)
                    
                    Text("공유하기")
                        .font(.TextButton)
                        .foregroundStyle(Color.TextBlack)
                }
                .padding(.horizontal, 41)
                .padding(.vertical, 14)
                .frame(width: 345, alignment: .center)
                .background(Color.shoakYellow)
                .cornerRadius(9)
                .overlay(
                    RoundedRectangle(cornerRadius: 9)
                        .inset(by: 0.5)
                        .stroke(Color.StrokeGray, lineWidth: 1)
                )
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("에러"), message: Text(alertMessage), dismissButton: .default(Text("확인")))
            }
            .padding(.top, 6)
            
        }
        .padding(8)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 17)
                .inset(by: 0.5)
                .stroke(.black.opacity(0.1), lineWidth: 1)
        )
        .padding(.horizontal, 16)
        .sheet(isPresented: $showMessageCompose) {
            MessageComposeView(isPresented: $showMessageCompose, useCase: invitationManager.inviteUseCase)
        }
    }
}
