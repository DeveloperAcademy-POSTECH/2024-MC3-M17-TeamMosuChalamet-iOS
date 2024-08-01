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
                HStack(spacing: 0){
                    Image(systemName: "person.circle.fill")
                        .font(.icon)
                    
                    Text("내 프로필")
                        .font(.textBody)
                        .foregroundStyle(Color.textBlack)
                        .padding(.leading, 6)
                    
                    Spacer()
                }
                .padding(10)
                
                Divider()
                    .padding(.vertical, 6)
                
                VStack(alignment: .center, spacing: 10) {
                    if let imageURLString = accountManager.profile?.imageURL,
                       let imageURL = URL(string: imageURLString) {
                        AsyncImage(url: imageURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .clipShapeBorder(RoundedRectangle(cornerRadius: 30), Color.strokeGray, 1.0)
                        } placeholder: {
                            ProgressView()
                                .frame(width: 80, height: 80)
                                .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                                .cornerRadius(30)
                        }
                    } else {
                        Image(.defaultProfile)
                            .resizable()
                            .frame(width: 80, height: 80)
                            .clipShapeBorder(RoundedRectangle(cornerRadius: 30), Color.strokeGray, 1.0)
                    }
                    
                    Text(accountManager.profile?.name ?? "쇽")
                        .font(.textTitle)
                        .foregroundStyle(Color.textBlack)
                        .padding(.bottom, 20)
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
        .sheet(isPresented: $showMessageCompose) {
            MessageComposeView(isPresented: $showMessageCompose, useCase: invitationManager.inviteUseCase)
        }
    }
}
