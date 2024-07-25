//
//  ContentView.swift
//  ShoakWatch Watch App
//
//  Created by 정종인 on 7/25/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(NavigationModel.self) private var navigationModel
    var body: some View {
        navigationModel.view
    }
}

#Preview {
    ContentView()
}
