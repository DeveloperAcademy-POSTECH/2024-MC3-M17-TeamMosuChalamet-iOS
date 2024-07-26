
import SwiftUI

struct SettingView: View {
    @Environment(NavigationModel.self) private var navigationModel
    var body: some View {
        Text("Setting")

        Button("Go to Friend List") {
            navigationModel.setView(to: .friendList)
        }
    }
}

#Preview {
    SettingView()
}
