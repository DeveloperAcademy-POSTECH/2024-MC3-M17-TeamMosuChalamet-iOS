//
//  BackButton.swift
//  Shoak
//
//  Created by 정종인 on 7/31/24.
//

import SwiftUI

struct BackButton: View {
    @Environment(NavigationManager.self) private var navigationManager
    let buttonAction: (() -> Void)?
    init(buttonAction: (() -> Void)? = nil) {
        self.buttonAction = buttonAction
    }
    var body: some View {
        Button {
            if let buttonAction {
                buttonAction()
            } else {
                self.navigationManager.setPrevView()
            }
        } label: {
            Image(systemName: "chevron.left")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.vertical, 13)
                .padding(.horizontal, 16)
                .background(Color.shoakWhite)
        }
        .buttonStyle(.plain)
        .clipShapeBorder(RoundedRectangle(cornerRadius: 9), Color.strokeBlack, 1.0)
    }
}
