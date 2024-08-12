//
//  DeleteFriendView.swift
//  Shoak
//
//  Created by 정종인 on 8/6/24.
//

import SwiftUI

struct DeleteFriendView: View {
    @Environment(ShoakDataManager.self) private var shoakDataManager
    var body: some View {
        VStack(spacing: 32) {
            TopButtons()
            FriendList()
        }
        .onAppear {
            shoakDataManager.refreshFriends()
        }
    }

    struct TopButtons: View {
        @Environment(NavigationManager.self) private var navigationManager
        var body: some View {
            ZStack(alignment: .center) {
                HStack {
                    BackButton()
                        .frame(maxHeight: 44)
                    
                    Spacer()
                }
                
                Text("친구삭제")
                    .font(.textPageTitle)
            }
            .padding(.horizontal, 16)
        }
    }

    struct FriendList: View {
        @Environment(ShoakDataManager.self) private var shoakDataManager
        var body: some View {
            List(shoakDataManager.friends, id: \.memberID) { friend in
                FriendListView.FriendButton(friend: friend, property: .delete)
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
