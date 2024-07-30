
import SwiftUI

struct FriendListView: View {
    @Environment(ShoakDataManager.self) private var shoakDataManager
    var body: some View {
        VStack {
            TopButtons()
            FriendsList()
        }
        .onAppear {
            shoakDataManager.refreshFriends()
        }
    }

    struct TopButtons: View {
        @Environment(NavigationManager.self) private var navigationManager
        var body: some View {
            HStack {
                Button {
                    navigationManager.setView(to: .inviteFriends)
                } label: {
                    Image(systemName: "person.fill.badge.plus")
                        .resizable()
                        .aspectRatio(1.0, contentMode: .fit)
                        .frame(maxHeight: 38)
                        .foregroundStyle(Color.textBlack)
                        .padding(.top, 4)
                        .padding(.leading, 4) // 아이콘 자체가 치우쳐져 있어서 미세조정
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.shoakYellow, ignoresSafeAreaEdges: [])
                        // https://developer.apple.com/documentation/swiftui/view/background(_:ignoressafeareaedges:)
                }
                .buttonStyle(.plain)
                .clipShape(RoundedRectangle(cornerRadius: 12))


                Button {
                    navigationManager.setView(to: .settings)
                } label: {
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .aspectRatio(1.0, contentMode: .fit)
                        .frame(maxHeight: 38)
                        .padding(.horizontal, 24)
                        .foregroundStyle(Color.textWhite)
                        .frame(maxHeight: .infinity)
                        .background(Color.shoakRed, ignoresSafeAreaEdges: [])
                }
                .buttonStyle(.plain)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .frame(height: 60)
            .padding(.horizontal, 16)
        }
    }

    struct FriendsList: View {
        @Environment(ShoakDataManager.self) private var shoakDataManager
        @Environment(NavigationManager.self) private var navigationManager

        var body: some View {
            List(shoakDataManager.friends, id: \.memberID) { member in
                FriendButton(friend: member)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .padding(.horizontal, 16)
            }
            .listRowSpacing(5)
            .listStyle(.plain)
            .refreshable {
                shoakDataManager.refreshFriends()
            }
        }
    }

    struct FriendButton: View {
        var friend: TMFriendVO

        @State private var property: Properties = .default

        init(friend: TMFriendVO, property: Properties = .default) {
            self.friend = friend
            self._property = State(initialValue: property)
        }

        var body: some View {
            Button {
                property.tapAction()
            } label: {
                HStack {
                    Image(systemName: "person.fill")
                        .resizable()
                        .padding()
                        .frame(width: 80, height: 80)
                        .clipShapeBorder(RoundedRectangle(cornerRadius: 30), Color.strokeGray, 2.0)
                        .padding(15)

                    Text(friend.name)
                        .font(.textTitle)

                    Spacer()

                    property.accessoryView
                        .frame(width: 100, height: 60)
                        .padding(.trailing, 23)
                }
                .frame(minHeight: 110)
                .background(property.backgroundColor)
            }
            .buttonStyle(.plain)
            .clipShapeBorder(RoundedRectangle(cornerRadius: 12), Color.strokeBlack, 1.0)
        }

        enum Properties {
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
                        .frame(width: 98, height:51)
                        .background(Color.shoakNavy, in: Capsule(style: .continuous))
                case .complete:
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .frame(width: 61, height: 61)
                        .foregroundStyle(Color.shoakGreen)
                case .delete:
                    Image(systemName: "trash.fill")
                        .foregroundStyle(Color.shoakWhite)
                        .frame(width: 98, height:51)
                        .background(Color.shoakRed, in: Capsule(style: .continuous))
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
