//
//  View+ClipShapeBorder.swift
//  Shoak
//
//  Created by 정종인 on 7/30/24.
//

import SwiftUI

struct ClipShapeBorder<T: Shape>: ViewModifier {
    let shape: T
    let strokeStyle: StrokeStyle
    func body(content: Content) -> some View {
        content
            .clipShape(shape)
            .overlay {
                shape
                    .fill(Color.clear)
                    .stroke(shape, style: strokeStyle)
            }
    }
}
