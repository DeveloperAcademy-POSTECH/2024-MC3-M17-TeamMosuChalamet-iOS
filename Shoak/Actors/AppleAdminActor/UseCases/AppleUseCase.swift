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
    /// Sign in with Apple -> userID, name, token 추출, token은 기기에 저장
    func extractCredential(_ authorization: ASAuthorization) -> TMUserCredentialVO? {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            guard let token = appleIDCredential.identityToken,
                  let tokenString = String(data: token, encoding: .utf8)
            else {
                return nil
            }
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let name = (fullName?.familyName ?? "") + (fullName?.givenName ?? "")

            print("userID : \(userIdentifier)") // 유저ID는 항상 동일함
            print("name :  \(name)")
            print("token : \(tokenString)") // 토큰은 로그인 할때마다 달라짐.
            TokenManager().save(IdentityToken(tokenString))
            return TMUserCredentialVO(userID: userIdentifier, name: name, token: tokenString)
        default:
            return nil
        }
    }

    // Sign in with Apple
    func handleSignInSuccess(authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            guard let token = appleIDCredential.identityToken,
                  let tokenString = String(data: token, encoding: .utf8)
            else {
                return
            }
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let name = (fullName?.familyName ?? "") + (fullName?.givenName ?? "")
            
            print("userID : \(userIdentifier)") // 유저ID는 항상 동일함
            print("name :  \(name)")
            print("token : \(tokenString)") // 토큰은 로그인 할때마다 달라짐.
        default:
            break
        }
    }
    
    func handleSignInFailure(error: Error) {
        print(error)
    }
}
