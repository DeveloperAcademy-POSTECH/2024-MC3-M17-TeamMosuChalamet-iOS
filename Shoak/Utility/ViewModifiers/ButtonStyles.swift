//
//  ButtonStyles.swift
//  Shoak
//
//  Created by 정종인 on 8/8/24.
//

import SwiftUI

public struct ShrinkingButtonStyle: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.8 : 1)
            .animation(.linear(duration: 0.2), value: configuration.isPressed)
    }
}

public struct FilledButtonStyle: ButtonStyle {
    public let labelColor = Color.textBlack
    public let backgroundColor = Color.shoakYellow
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(Color.textBlack)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(Color.shoakYellow)
            .clipShapeBorder(RoundedRectangle(cornerRadius: 9), Color.strokeBlack, 1)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.linear(duration: 0.2), value: configuration.isPressed)
    }
}
