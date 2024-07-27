
import SwiftUI

struct FriendListView: View {
    @Environment(ShoakDataManager.self) private var shoakDataManager
    @Environment(NavigationModel.self) private var navigationModel

    var body: some View {
        VStack {
            List(shoakDataManager.friends, id: \.memberID) { member in
                Text("member name : \(member.name)")
            }

            Button("Go to Setting") {
                navigationModel.setView(to: .settings)
            }
        }
    }
}

#Preview {
    FriendListView()
}
