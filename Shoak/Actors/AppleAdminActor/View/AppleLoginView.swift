//
//  AppleLoginView.swift
//  Shoak
//
//  Created by KimYuBin on 7/25/24.
//

import SwiftUI
import AuthenticationServices
import MessageUI

struct AppleLoginView: View {
    let useCase: AppleUseCase
    
    @State private var showMessageCompose = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack {
            Button(action: {
                if MFMessageComposeViewController.canSendText() {
                    showMessageCompose = true
                } else {
                    alertMessage = "이 장치는 문자 메시지를 보낼 수 없습니다."
                    showAlert = true
                }
            }) {
                Text("iMessage")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("에러"), message: Text(alertMessage), dismissButton: .default(Text("확인")))
            }
            
            AppleSignInButton(
                onSignInSuccess: { authorization in
                    useCase.handleSignInSuccess(authorization: authorization)
                },
                onSignInFailure: { error in
                    useCase.handleSignInFailure(error: error)
                }
            )
            .frame(height:UIScreen.main.bounds.height)
        }
        .sheet(isPresented: $showMessageCompose) {
            MessageComposeView(isPresented: $showMessageCompose, useCase: useCase)
        }
    }
}
