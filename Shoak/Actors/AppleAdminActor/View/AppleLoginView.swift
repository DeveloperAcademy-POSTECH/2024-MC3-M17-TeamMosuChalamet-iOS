//
//  AppleLoginView.swift
//  Shoak
//
//  Created by KimYuBin on 7/25/24.
//

import SwiftUI
import AuthenticationServices

struct AppleLoginView: View {
    @Environment(AccountManager.self) private var accountManager

    let onSignInSuccess: ((TMUserCredentialVO) -> Void)?
    let onSignInFailure: ((Error?) -> Void)?

    var body: some View {
        VStack {
            AppleSignInButton(
                onSignInSuccess: { authorization in
                    // extractCredential 시 token 저장도 같이 함
                    guard let credential = accountManager.appleUseCase.extractCredential(authorization) else {
                        onSignInFailure?(nil)
                        return
                    }

                    onSignInSuccess?(credential)
                },
                onSignInFailure: { error in
                    onSignInFailure?(error)
                }
            )
            .padding(.bottom, 57)
        }
    }
}
