
import SwiftUI
import WatchKit
import Combine

struct WatchFriendListView: View {
    
    @Environment(ShoakDataManager.self) private var shoakDataManager
    @Environment(NavigationManager.self) private var navigationManager

    var body: some View {
        List {
            Button {
                shoakDataManager.refreshFriends()
            } label: {
                Label("새로 고침", systemImage: "arrow.counterclockwise")
            }
            .buttonStyle(.borderedProminent)


            if !shoakDataManager.isLoading && shoakDataManager.friends.isEmpty {
                Text("휴대폰에서 다시 로그인 해주세요")
            } else if shoakDataManager.isLoading {
                ProgressView()
            } else if shoakDataManager.friends.isEmpty {
                Text("휴대폰에서 친구를 추가해주세요")
            } else {
                ForEach(shoakDataManager.friends, id: \.memberID) { friend in
                    FriendButton(friend: friend)
                }
            }
        }
        .task {
            self.shoakDataManager.refreshFriends()
        }
    }

    struct FriendButton: View {
        enum TapState {
            case none
            case loading
            case completed
            case failed
        }
        @Environment(ShoakDataManager.self) private var shoakDataManager
        var friend: TMFriendVO
        let hapticManager = HapticManager.instance
        @State private var isTapped: TapState = .none
        @State private var friendImage: Image?
        @State private var cancellable: AnyCancellable?
        var body: some View {
            Button(action: {
                isTapped = .loading

                hapticManager.notification(type: .retry)

                Task {
                    let result = await self.shoakDataManager.sendShoak(to: friend.memberID)
                    DispatchQueue.main.async {
                        switch result {
                        case .success:
                            isTapped = .completed
                        case .failure(let failure):
                            print(failure)
                            isTapped = .failed
                        }
                        // 1초 뒤에 isTapped = .none으로 바꾸기
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            isTapped = .none
                        }
                    }
                }
            }) {

                HStack(spacing: 0) {
                    switch isTapped {
                    case .none:
                        if friend.imageURLString != nil {
                            Group {
                                if let friendImage {
                                    friendImage
                                        .resizable()
                                } else {
                                    ProgressView()
                                }
                            }
                            .frame(width: 50, height: 50)
                            .clipShapeBorder(RoundedRectangle(cornerRadius: 20), Color.strokeGray, 1.0)
                        }
                        else {
                            Image("EmptyProfile")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .clipShapeBorder(RoundedRectangle(cornerRadius: 20), Color.strokeGray, 1.0)
                        }
                    case .loading:
                        ProgressView()
                            .frame(width: 50, height: 50)
                    case .completed:
                        Image("Check")
                            .resizable()
                            .frame(width: 50, height: 50)
                    case .failed:
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }

                    Spacer()
                        .frame(width: 24)

                    Text("\(friend.name)")
                        .font(.textListTitle)
                        .foregroundColor(isTapped == .completed ? Color.textWhite : Color.textBlack)
                    Spacer()
                }
                .frame(width: 174, height: 82)
                .padding()
            }
            .listRowBackground(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isTapped == .completed ? Color.shoakGreen : Color.shoakYellow )
                    .clipShapeBorder(RoundedRectangle(cornerRadius: 20), isTapped == .completed ? Color.WatchStrokeGreen : Color.WatchStrokeYellow, 2)
            )
            .onAppear {
                if let imageURLString = friend.imageURLString, let imageURL = URL(string: imageURLString) {
                    cancellable = loadImage(from: imageURL)
                        .sink(receiveCompletion: { _ in }, receiveValue: { image in
                            self.friendImage = image
                        })
                }
            }
            .onDisappear {
                cancellable?.cancel()
            }
            .animation(.default, value: isTapped)
        }

        private func loadImage(from url: URL) -> AnyPublisher<Image, Error> {
            return URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { (data, response) -> Image in
                    guard let uiImage = UIImage(data: data) else {
                        throw URLError(.badServerResponse)
                    }
                    return Image(uiImage: uiImage)
                }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
    }

}

class HapticManager {
    static let instance = HapticManager()
    private init() {}
    
    func notification(type: WKHapticType) {
        let device = WKInterfaceDevice.current()
        device.play(type)
    }
    
    func playRepeatedHaptic(type: WKHapticType, times: Int, interval: TimeInterval) {
        let device = WKInterfaceDevice.current()
        for i in 0..<times {
            DispatchQueue.main.asyncAfter(deadline: .now() + interval * Double(i)) {
                device.play(type)
            }
        }
    }

}

#Preview {
    WatchFriendListView()
        .addEnvironmentsForPreview()

}
