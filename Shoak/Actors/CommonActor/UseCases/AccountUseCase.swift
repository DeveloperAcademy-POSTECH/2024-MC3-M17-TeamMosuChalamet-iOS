
final class AccountUseCase {
    func isLoggedIn() -> Bool {
        return false
    }

    func getMyMemberID() -> TMMemberID? {
        return 12323423442
    }
}

// Sendable은 Intent에서 사용하기 위해 채택하였음.
extension AccountUseCase: Sendable {}
