//
//  RootView.swift
//  Shoak
//
//  Created by 정종인 on 7/25/24.
//

import SwiftUI

struct RootView: View {
    @Environment(NavigationManager.self) private var navigationManager
    var body: some View {
        Color.bgGray
            .ignoresSafeArea()
            .overlay {
                navigationManager.view
            }
    }
}

#Preview {
    RootView()
        .addEnvironmentsForPreview()
}
