
import SwiftUI

struct SettingView: View {
    @Environment(NavigationManager.self) private var navigationManager
    var body: some View {
        Text("Setting")

        Button("Go to Friend List") {
            navigationManager.setView(to: .friendList)
        }
    }
}

#Preview {
    SettingView()
}
