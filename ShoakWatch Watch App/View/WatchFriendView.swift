//
//  WatchFriendView.swift
//  ShoakWatch Watch App
//
//  Created by yeji on 7/30/24.
//

import SwiftUI

let YcustomColor = Color(red: 255 / 255, green: 202 / 255, blue: 0 / 255)
let GcustomColor = Color(red: 113 / 255, green: 198 / 255, blue: 73 / 255)


struct WatchFriendView: View {
    @Environment(ShoakDataManager.self) private var shoakDataManager
    @Environment(NavigationManager.self) private var navigationManager
    @State private var isTapped = true
    
    var body: some View {
        
        List(shoakDataManager.friends, id: \.memberID) { member in
            Button(action: {
                // 버튼 클릭 시 수행할 동작
                isTapped.toggle()
                
                print("Selected member: \(member.name)")
            }) {
                HStack {
                    if isTapped {
                        if let urlString = member.imageURLString, let url = URL(string: urlString) {
                            AsyncImage(url: url) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        }
                    }
                    else {
                        Image("Check")
                            .resizable()
                            .frame(width: 50, height: 50)
                           
                    }
                        
                    Text("member name : \(member.name)")
                        .foregroundColor(isTapped ? Color.black : Color.white)
                    
                }
                .padding()
            }
            .listRowBackground(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isTapped ? YcustomColor : GcustomColor)
            )
        }
        
    }
}
#Preview {
    WatchFriendView()
        .environment(ShoakDataManager.shared)
        .environment(NavigationManager())

}
