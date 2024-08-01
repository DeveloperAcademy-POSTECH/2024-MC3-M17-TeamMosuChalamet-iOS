
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
                    //리스트 눌리면 UI 변경
                    Button(action: {
                        tappedStates[member.memberID, default: false].toggle()
                        
                        //햅틱 피드백
                        hapticManager.playRepeatedHaptic(type: .retry, times: 3, interval: 0.00001)
                        //                hapticManager.notification(type: .retry)
                        
                        // tap 된 버튼 일정 시간 지나면 복원
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            tappedStates[member.memberID] = false
                        }
                        print("Selected member: \(member.name)")
                        
                        Task {
                            await shoakDataManager.sendShoak(to: member.memberID)
                        }
                    }) {
                        HStack {
                            if tappedStates[member.memberID, default: false] {
                                Image("Check")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                
                            } else {
                                Image("EmptyProfile")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                            }
                            Spacer()
                            Text("member name : \(member.name)")
                                .foregroundColor(tappedStates[member.memberID, default: false] ? Color.white : Color.black)
                            
                            
                        }
                        .padding()
                    }
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(tappedStates[member.memberID, default: false] ? Color.shoakGreen : Color.shoakYellow )
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
        .environment(NavigationManager())
    
}
