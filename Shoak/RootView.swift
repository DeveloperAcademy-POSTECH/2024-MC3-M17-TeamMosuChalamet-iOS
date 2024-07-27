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
        navigationManager.view
    }
}

#Preview {
    RootView()
}
