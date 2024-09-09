//
//  CheckMyProfileView.swift
//  Shoak
//
//  Created by chongin on 9/8/24.
//

import SwiftUI

struct CheckMyProfileView: View {
    @Environment(NavigationManager.self) private var navigationManager

    let onNext: () -> Void
    var body: some View {
        VStack {
            Spacer()
            Text("다음 프로필로 시작합니다")
                .font(.textListTitle)
                .foregroundStyle(Color.textBlack)
                .multilineTextAlignment(.center)
                .padding(.bottom, 35)
            MyProfileView()
            Spacer()
            BottomButton {
                onNext()
            }
        }
        .padding()
    }
}

#Preview {
    CheckMyProfileView(onNext: {})
        .addEnvironmentsForPreview()
}
