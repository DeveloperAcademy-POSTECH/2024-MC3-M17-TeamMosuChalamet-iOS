//
//  AppleSignInButton.swift
//  Shoak
//
//  Created by KimYuBin on 7/25/24.
//

import SwiftUI
import AuthenticationServices

struct AppleSignInButton: View {
    let onSignInSuccess: (ASAuthorization) -> Void
    let onSignInFailure: (Error) -> Void
    
    var body: some View {
        SignInWithAppleButton(
            onRequest: { request in
                request.requestedScopes = [.fullName]
            },
            onCompletion: { result in
                switch result {
                case .success(let authorization):
                    onSignInSuccess(authorization)
                case .failure(let error):
                    onSignInFailure(error)
                }
            }
        )
        .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
        .cornerRadius(5)
    }
}
