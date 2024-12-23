import SwiftUI
import Lottie
import StoreKit

struct FriendListView: View {
    @Environment(ShoakDataManager.self) private var shoakDataManager
    @Environment(NavigationManager.self) private var navigationManager
#if APPCLIP
    @State private var showAppStoreOverlay = false
#endif
    var body: some View {
        @Bindable var navigationManager = navigationManager
        VStack {
            TopButtons(friendCount: shoakDataManager.friends.count)
            FriendsList()
        }
        .onAppear {
            shoakDataManager.refreshFriends()
#if APPCLIP
            showAppStoreOverlay = true
#endif
        }
        .sheet(item: $navigationManager.invitation) { invitation in
            AcceptInvitationView()
        }
#if APPCLIP
        .appStoreOverlay(isPresented: $showAppStoreOverlay) {
            SKOverlay.AppClipConfiguration(position: .bottom)
        }
#endif
    }
    
    struct TopButtons: View {
        @Environment(NavigationManager.self) private var navigationManager
        var friendCount: Int
        @State private var isShowingFriendLimitAlert = false

        var body: some View {
            HStack {
                Button {
                    if friendCount >= 20 {
                        isShowingFriendLimitAlert = true
                    } else {
                        navigationManager.setView(to: .inviteFriends)
                    }
                } label: {
                    Image(systemName: "person.fill.badge.plus")
                        .resizable()
                        .aspectRatio(1.0, contentMode: .fit)
                        .frame(maxHeight: 38)
                        .foregroundStyle(Color.textBlack)
                        .padding(.top, 4)
                        .padding(.leading, 4)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.shoakYellow, ignoresSafeAreaEdges: [])
                        .clipShapeBorder(RoundedRectangle(cornerRadius: 12), Color.strokeBlack, 1)
                    // https://developer.apple.com/documentation/swiftui/view/background(_:ignoressafeareaedges:)
                }
                .buttonStyle(ShrinkingButtonStyle())
                .alert("친구 추가 불가", isPresented: $isShowingFriendLimitAlert) {
                    Button("확인", role: .cancel) {}
                } message: {
                    Text("최대 친구 수(20명)를 초과했습니다.\n더 이상 친구를 추가할 수 없습니다.")
                }

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
                        .clipShapeBorder(RoundedRectangle(cornerRadius: 12), Color.strokeBlack, 1)
                }
                .buttonStyle(ShrinkingButtonStyle())
            }
            .frame(height: 60)
            .padding(.horizontal, 16)
        }
    }
    
    struct FriendsList: View {
        @Environment(ShoakDataManager.self) private var shoakDataManager
        @Environment(NavigationManager.self) private var navigationManager
        
        var body: some View {
            if shoakDataManager.friends.isEmpty {
                VStack {
                    Spacer()
                    
                    Button(action: {
                        navigationManager.setView(to: .inviteFriends)
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .foregroundStyle(Color.textBlack)
                                .padding(.trailing, 8)
                            
                            Text("친구 추가하기")
                                .font(.textTitle)
                                .foregroundStyle(Color.textBlack)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                        .background(Color.shoakWhite)
                        .cornerRadius(25)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .inset(by: 0.5)
                                .stroke(Color.strokeBlack, lineWidth: 1)
                        )
                    }
                    
                    Spacer()
                }
            } else {
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
    }
    
    struct FriendButton: View {
        @Environment(ShoakDataManager.self) private var shoakDataManager
        
        var friend: TMFriendVO
        
        @State private var property: Properties = .default
        @State private var isPresentingDeleteFriendAlert = false
        @State private var cancellableItem: DispatchWorkItem?

        init(friend: TMFriendVO, property: Properties = .default) {
            self.friend = friend
            self._property = State(initialValue: property)
        }
        
        var body: some View {
            Button {
                cancellableItem?.cancel()
                self.cancellableItem = DispatchWorkItem {
                    if self.property == .confirm {
                        self.property = .default
                    }
                }
                switch self.property {
                case .default:
                    property = .confirm
                    if let cancellableItem {
                        DispatchQueue.main
                            .asyncAfter(
                                deadline: .now() + 4.5,
                                execute: cancellableItem
                            )
                    }
                case .confirm:
                    property = .default
                    cancellableItem?.cancel()
                case .delete:
                    self.isPresentingDeleteFriendAlert = true
                default:
                    break
                }
            } label: {
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
                }
                .frame(minHeight: 110)
                .background(property.backgroundColor)
                .overlay(alignment: .trailing) {
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
                .contentShape(Rectangle())
                .clipShapeBorder(RoundedRectangle(cornerRadius: 12), Color.strokeBlack, 1.0)
            }
            .buttonStyle(ShrinkingButtonStyle())
            .transition(.identity)
            .animation(.default, value: self.property)
            .alert(
                "친구를 삭제하시겠습니까?",
                isPresented: $isPresentingDeleteFriendAlert
            ) {
                Button("취소", role: .cancel) {}
                Button("삭제", role: .destructive) {
                    Task {
                        if case .success = await shoakDataManager.deleteFriend(memberID: self.friend.memberID) {
                            self.shoakDataManager.refreshFriends()
                        }
                    }
                }
            } message: {
                Text("삭제 시 되돌릴 수 없으며, 다시 친구 신청을 보내야 합니다.")
            }
        }
        
        private func sendShoak() {
            Task {
                property = .loading
                let result = await shoakDataManager.sendShoak(to: friend.memberID)
                switch result {
                case .success:
                    HapticManager.shared.playSuccessHaptic()
                    property = .complete
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        property = .default
                    }
                case .failure:
                    HapticManager.shared.playFailureHaptic()
                    property = .failed
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        property = .default
                    }
                }
            }
        }
        
        enum Properties {
            case `default`
            case confirm
            case loading
            case complete
            case failed
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
                            .opacity(0.8)
                            .frame(width: 70, height: 70)
                            .background(Color.shoakNavy)
                            .clipShapeBorder(Circle(), Color.strokeWhite, 1)
                    }
                    .buttonStyle(ShrinkingButtonStyle())
                case .loading:
                    ProgressView()
                case .complete:
                    LottieView(animation: .named("Check"))
                        .playing()
                        .resizable()
                        .frame(width: 70, height: 70)
                        .foregroundStyle(Color.shoakGreen)
                case .failed:
                    Image(systemName: "xmark")
                        .resizable()
                        .padding()
                        .frame(width: 70, height: 70)
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
        .addEnvironmentsForPreview()
}
