//
//  AppleUseCase.swift
//  Shoak
//
//  Created by KimYuBin on 7/25/24.
//

import Foundation
import SwiftUI
import AuthenticationServices

class AppleUseCase {
    func handleSignInSuccess(authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let token = appleIDCredential.identityToken
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let name = (fullName?.familyName ?? "") + (fullName?.givenName ?? "")
            
            print("userID : \(userIdentifier)")
            print("name :  \(name)")
        default:
            break
        }
    }
    
    func handleSignInFailure(error: Error) {
        print(error)
    }
}
