//
//  BottomButton.swift
//  Shoak
//
//  Created by chongin on 9/8/24.
//

import SwiftUI

struct BottomButton: View {
    let action: () -> Void
    let text: LocalizedStringKey
    let backgroundColor: Color
    let textColor: Color
    init(text: LocalizedStringKey = "다음", backgroundColor: Color = .shoakYellow, textColor: Color = .textBlack, action: @escaping () -> Void) {
        self.text = text
        self.action = action
        self.backgroundColor = backgroundColor
        self.textColor = textColor
    }
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 16) {
                Spacer()

                Image(systemName: "chevron.right") // 중앙을 적절히 맞추기 위한 장치
                    .hidden()

                Text(text)
                    .font(.textButton)
                    .frame(maxHeight: 58)

                Image(systemName: "chevron.right")

                Spacer()
            }
            .background(backgroundColor)
            .foregroundStyle(textColor)
        }
        .buttonStyle(.plain)
        .clipShapeBorder(RoundedRectangle(cornerRadius: 12), Color.strokeBlack, 1)
    }
}
