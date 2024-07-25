//
//  RootView.swift
//  Shoak
//
//  Created by 정종인 on 7/25/24.
//

import SwiftUI

struct RootView: View {
    @Environment(NavigationModel.self) private var navigationModel
    var body: some View {
        navigationModel.view
    }
}

#Preview {
    RootView()
}
