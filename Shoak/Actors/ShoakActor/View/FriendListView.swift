
import SwiftUI

struct FriendListView: View {
    @Environment(ShoakDataManager.self) private var shoakDataManager
    @Environment(NavigationManager.self) private var navigationManager

    var body: some View {
        VStack {
            List(shoakDataManager.friends, id: \.memberID) { member in
                Text("member name : \(member.name)")
            }
            .refreshable {
                shoakDataManager.refreshFriends()
            }

            Button("Go to Setting") {
                navigationManager.setView(to: .settings)
            }

            Button("Go to Onboarding") {
                navigationManager.setView(to: .onboarding)
            }
        }
    }
}

#Preview {
    FriendListView()
}
