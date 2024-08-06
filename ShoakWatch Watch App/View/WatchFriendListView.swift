
import SwiftUI
import WatchKit

struct WatchFriendListView: View {
    
    @Environment(ShoakDataManager.self) private var shoakDataManager
    @Environment(NavigationManager.self) private var navigationManager
    @State private var tappedStates: [TMMemberID: Bool] = [:]
    let hapticManager = HapticManager.instance
    
    var body: some View {
        
        Group {
            if shoakDataManager.friends.isEmpty {
                ProgressView()
            } else {
                
                List(shoakDataManager.friends, id: \.memberID) { member in
                    Button(action: {
                        tappedStates[member.memberID, default: false].toggle()
                        
                        hapticManager.notification(type: .retry)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            tappedStates[member.memberID] = false
                        }
                        
                        Task {
                            await shoakDataManager.sendShoak(to: member.memberID)
                        }
                    }) {
                        
                        HStack(spacing: 0) {
                            if tappedStates[member.memberID, default: false] {
                                Image("Check")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                
                            } else {
                                if let urlString = member.imageURLString, let url = URL(string: urlString) {
                                    AsyncImage(url: url) { image in
                                        image.resizable()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 50, height: 50)
                                    .clipShapeBorder(RoundedRectangle(cornerRadius: 20), Color.strokeGray, 1.0)
                                }
                                else{
                                    Image("EmptyProfile")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .clipShapeBorder(RoundedRectangle(cornerRadius: 20), Color.strokeGray, 1.0)
                                        
                                }
                            }
                            Spacer()
                                .frame(width: 24)
                            
                            Text("\(member.name)")
                                .font(.textListTitle)
                                .foregroundColor(tappedStates[member.memberID, default: false] ? Color.textWhite : Color.textBlack)
                            Spacer()
                        }
                        .frame(width: 174, height: 82)
                        .padding()
                    }
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(tappedStates[member.memberID, default: false] ? Color.shoakGreen : Color.shoakYellow )
                            .clipShapeBorder(RoundedRectangle(cornerRadius: 20),tappedStates[member.memberID, default: false] ? Color.WatchStrokeGreen : Color.WatchStrokeYellow, 2)
                    )
                    
                }
                
            }
        }
        .onAppear {
            self.shoakDataManager.refreshFriends()
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
        .environment(ShoakDataManager.shared)
        .environment(NavigationManager.shared)
    
}
