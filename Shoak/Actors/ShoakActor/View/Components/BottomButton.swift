//
//  BottomButton.swift
//  Shoak
//
//  Created by chongin on 9/8/24.
//

import SwiftUI

struct BottomButton: View {
    let action: () -> Void
    let text: String = "다음"
    var body: some View {
        Button {
            action()
        } label: {
            Text(text)
                .font(.textButton)
                .frame(maxWidth: .infinity, maxHeight: 58)
                .background(Color.shoakYellow)
                .overlay {
                    Image(systemName: "chevron.right")
                        .offset(x: 30)
                }
        }
        .buttonStyle(.plain)
        .clipShapeBorder(RoundedRectangle(cornerRadius: 12), Color.strokeBlack, 1)
    }
}
