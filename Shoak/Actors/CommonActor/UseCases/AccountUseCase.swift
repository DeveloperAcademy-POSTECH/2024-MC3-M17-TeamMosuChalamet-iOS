
final class AccountUseCase {
    func isLoggedIn() -> Bool {
        return false
    }

    func getMyMemberID() -> TMMemberID? {
        return "My Member ID"
    }
}

// Sendable은 Intent에서 사용하기 위해 채택하였음.
extension AccountUseCase: Sendable {}
