//
//  WatchNotificationView.swift
//  ShoakWatch Watch App
//
//  Created by yeji on 7/31/24.
//

import SwiftUI

struct 
WatchNotificationView: View {
    var message: String?
    var profile: TMProfileVO?

    var body: some View {
        VStack {
            
            if let profile {
                if let imageURL = profile.imageURL, let url = URL(string: imageURL) {
                    AsyncImage(url: url) { image in
                        CircleImage( image: image.resizable())
                    } placeholder: {
                        ProgressView()
                    }
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: 100, height: 100)
                }

                Text(profile.name)
                    .font(.headline)
            }

            Divider()

            Text(message ?? "쇽! 날쏘고가라")
                .font(.caption)
        }
    }
}

#Preview {
    WatchNotificationView(
        message: "쇽! 날쏘고가라.",
        profile: TMProfileVO(name: "이빈치", imageURL: "https://ada-mc3.s3.ap-northeast-2.amazonaws.com/profile/a7b899ae-528e-4e37-a6f1-e9ac08ab50c9vinci.jpeg")
    )
}

//#Preview {
//    WatchNotificationView()
//}
