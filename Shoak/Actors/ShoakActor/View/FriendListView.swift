
import SwiftUI

struct FriendListView: View {
    @Environment(ShoakDataManager.self) private var shoakDataManager
    @Environment(NavigationManager.self) private var navigationManager

    var body: some View {
        List(shoakDataManager.friends, id: \.memberID) { member in
            FriendButton(friend: member)
        }
        .listStyle(.plain)
        .listRowSeparator(.hidden)
        .refreshable {
            shoakDataManager.refreshFriends()
        }
    }

    struct FriendButton: View {
        var friend: TMFriendVO

        @State private var property: Properties = .confirm

        var body: some View {
            Button {
                property.tapAction()
            } label: {
                HStack {
                    Image(systemName: "person.fill")

                    Text(friend.name)

                    Spacer()

                    property.accessoryView
                        .frame(width: 100, height: 60)
                }
            }
            .buttonStyle(.plain)
            .frame(minHeight: 110)
            .background(property.backgroundColor)
        }

        private enum Properties {
            case `default`
            case confirm
            case complete
            case delete

            var backgroundColor: Color {
                switch self {
                case .confirm:
                    Color.shoakYellow
                default:
                    Color.shoakWhite
                }
            }

            @ViewBuilder
            var accessoryView: some View {
                switch self {
                case .default:
                    Color.clear.contentShape(Rectangle())
                case .confirm:
                    Text("부르기")
                        .font(.textTitle)
                        .foregroundStyle(Color.shoakWhite)
                        .padding(.horizontal, 21)
                        .padding(.vertical, 13)
                        .background(Color.shoakNavy, in: Capsule(style: .continuous))
                case .complete:
                    Image(systemName: "checkmark.circle")
                case .delete:
                    Image(systemName: "trash.fill")
                        .background(Color.shoakNavy, in: Capsule(style: .continuous))
                }
            }

            mutating func tapAction() {
                withAnimation {
                    switch self {
                    case .default:
                        self = .confirm
                    case .confirm:
                        self = .complete
                    case .complete:
                        self = .default
                    case .delete:
                        print("지우기 액션!!")
                    }
                }
            }
        }
    }
}

#Preview {
    FriendListView()
        .environment(ShoakDataManager.shared)
        .environment(AccountManager.shared)
        .environment(NavigationManager())
        .environment(InvitationManager.shared)

}
