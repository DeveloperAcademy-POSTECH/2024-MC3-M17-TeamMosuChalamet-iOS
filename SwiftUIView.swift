
import SwiftUI

struct MyPageView: View {
    let useCase: ShoakUseCase

    @State private var profile: TMProfileVO = TMProfileVO(memberID: "initial", name: "initial")
    var body: some View {
        Text("my name : \(profile.name)")

        Button("click!!") {
            profile = useCase.getUser(id: "asdf")
        }
    }
}
