
import SwiftUI

struct SettingView: View {
    @Environment(NavigationManager.self) private var navigationManager
    var body: some View {
        VStack {
            Text("Setting")
            
            Button("Go to Friend List") {
                navigationManager.setView(to: .friendList)
            }

            Button("logout!") {
                TokenManager().deleteAllTokensWithoutDeviceToken()
                navigationManager.setView(to: .login)
            }
        }
    }
}

#Preview {
    SettingView()
}
