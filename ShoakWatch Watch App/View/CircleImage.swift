//
//  CircleImage.swift
//  ShoakWatch Watch App
//
//  Created by yeji on 7/31/24.
//
import SwiftUI

struct CircleImage: View {
    var image: Image

    var body: some View {
        image
            .clipShape(Circle())
            .overlay {
                Circle().stroke(Color.shoakYellow, lineWidth: 4)
            }
            .shadow(radius: 7)
    }
}

#Preview {
    CircleImage(image: Image("turtlerock"))
}
