
import SwiftUI

struct MyPageView: View {
    let useCase: ShoakUseCase

    @State private var profile: TMProfileVO = TMProfileVO(memberID: "initial", name: "initial")
    var body: some View {
        VStack {
            Text("my name : \(profile.name)")

            if let url = URL(string: profile.imageURLString ?? "") {
                AsyncImage(url: url)
                    .frame(width: 200, height: 200)
            }

            Button("click!!") {
                profile = useCase.getProfile(id: "asdf")
            }
        }
    }
}
