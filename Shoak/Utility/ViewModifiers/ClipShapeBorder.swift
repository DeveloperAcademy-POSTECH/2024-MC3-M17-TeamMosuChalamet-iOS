//
//  ClipShapeBorder.swift
//  Shoak
//
//  Created by 정종인 on 7/30/24.
//

import SwiftUI

struct ClipShapeBorder<T: Shape, SS: ShapeStyle>: ViewModifier {
    let shape: T
    let shapeStyle: SS
    let strokeStyle: StrokeStyle
    func body(content: Content) -> some View {
        content
            .clipShape(shape)
            .overlay {
                shape
                    .fill(Color.clear)
                    .stroke(shapeStyle, style: strokeStyle)
            }
    }
}

extension View {
    func clipShapeBorder<T: Shape>(_ shape: T, _ lineColor: Color, _ lineWidth: CGFloat = 1.0) -> some View {
        let strokeStyle = StrokeStyle(lineWidth: lineWidth)

        return modifier(ClipShapeBorder(shape: shape, shapeStyle: lineColor, strokeStyle: strokeStyle))
    }

    func clipShapeBorder<T: Shape, SS: ShapeStyle>(_ shape: T, _ shapeStyle: SS, _ strokeStyle: StrokeStyle) -> some View {
        modifier(ClipShapeBorder(shape: shape, shapeStyle: shapeStyle, strokeStyle: strokeStyle))
    }
}
