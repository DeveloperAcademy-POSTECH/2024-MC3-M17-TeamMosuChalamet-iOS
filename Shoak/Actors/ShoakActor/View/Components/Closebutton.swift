//
//  Closebutton.swift
//  Shoak
//
//  Created by chongin on 9/23/24.
//

import SwiftUI

struct CloseButton: View {
    let buttonAction: (() -> Void)?
    init(buttonAction: (() -> Void)? = nil) {
        self.buttonAction = buttonAction
    }
    var body: some View {
        Button {
            if let buttonAction {
                buttonAction()
            }
        } label: {
            Image(systemName: "xmark")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.vertical, 13)
                .padding(.horizontal, 13)
                .background(Color.shoakWhite)
                .foregroundStyle(.red)
        }
        .buttonStyle(.plain)
        .clipShapeBorder(RoundedRectangle(cornerRadius: 9), Color.strokeBlack, 1.0)
    }
}
