//
//  AppleLoginView.swift
//  Shoak
//
//  Created by KimYuBin on 7/25/24.
//

import SwiftUI
import AuthenticationServices

struct AppleLoginView: View {
    let useCase: AppleUseCase
    
    var body: some View {
        VStack {
            AppleSignInButton(
                onSignInSuccess: { authorization in
                    useCase.handleSignInSuccess(authorization: authorization)
                },
                onSignInFailure: { error in
                    useCase.handleSignInFailure(error: error)
                }
            )
        }
        .frame(height:UIScreen.main.bounds.height)
    }
}
