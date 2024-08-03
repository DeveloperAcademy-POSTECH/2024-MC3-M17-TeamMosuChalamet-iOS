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
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(Color.strokeBlack, lineWidth: 1)
                )
                
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
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(Color.strokeBlack, lineWidth: 1)
                )
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
        @Environment(ShoakDataManager.self) private var shoakDataManager
        
        var friend: TMFriendVO
        
        @State private var property: Properties = .default
        
        var body: some View {
            HStack(spacing: 0) {
                if let imageURLString = friend.imageURLString,
                   let imageURL = URL(string: imageURLString) {
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .clipShapeBorder(RoundedRectangle(cornerRadius: 30), Color.strokeGray, 1.0)
                            .padding(.leading, 15)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 80, height: 80)
                            .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                            .cornerRadius(30)
                            .padding(.leading, 15)
                    }
                } else {
                    Image(.defaultProfile)
                        .resizable()
                        .frame(width: 80, height: 80)
                        .clipShapeBorder(RoundedRectangle(cornerRadius: 30), Color.strokeGray, 1.0)
                        .padding(.leading, 15)
                }
                
                Text(friend.name)
                    .font(.textTitle)
                    .padding(.leading, 19)
                
                Spacer()
                
                property.accessoryView(onButtonTapped: {
                    switch property {
                    case .confirm:
                        sendShoak()
                    default:
                        break
                    }
                })
                .frame(width: 100, height: 60)
                .padding(.trailing, 23)
            }
            .frame(minHeight: 110)
            .background(property.backgroundColor)
            .contentShape(Rectangle())
            .onTapGesture {
                if property == .default {
                    property = .confirm
                } else {
                    property = .default
                }
            }
            .clipShapeBorder(RoundedRectangle(cornerRadius: 12), Color.strokeBlack, 1.0)
            .animation(.default, value: self.property)
        }
        
        private func sendShoak() {
            Task {
                let result = await shoakDataManager.sendShoak(to: friend.memberID)
                switch result {
                case .success:
                    property = .complete
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        property = .default
                    }
                case .failure:
                    property = .default
                }
            }
        }
        
        enum Properties {
            case `default`
            case confirm
            case complete
            case delete
            
            var backgroundColor: Color {
                switch self {
                case .confirm:
                    return Color.shoakYellow
                default:
                    return Color.shoakWhite
                }
            }
            
            @ViewBuilder
            func accessoryView(onButtonTapped: @escaping () -> Void) -> some View {
                switch self {
                case .default:
                    Color.clear.contentShape(Rectangle())
                case .confirm:
                    Button(action: onButtonTapped) {
                        Image(.shoakHandGestureIcon)
                            .frame(width: 100, height: 51)
                            .background(Color.shoakNavy)
                            .cornerRadius(30)
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .strokeBorder(Color.strokeWhite, lineWidth: 1)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                case .complete:
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .frame(width: 61, height: 61)
                        .foregroundStyle(Color.shoakGreen)
                case .delete:
                    Image(systemName: "trash.fill")
                        .foregroundStyle(Color.shoakWhite)
                        .frame(width: 98, height: 51)
                        .background(Color.shoakRed, in: Capsule(style: .continuous))
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
