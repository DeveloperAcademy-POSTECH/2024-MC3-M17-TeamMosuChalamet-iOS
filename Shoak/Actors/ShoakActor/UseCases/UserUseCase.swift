import Foundation

final class UserUseCase {
    func getProfile(id: TMMemberID) -> Result<TMProfileVO, Errors> {
        let serverData: TMProfileDTO = .mockData // 서버 통신 후 가져온 DTO
        return .success(toVO(serverData)) // VO를 리턴
    }

    func getFriends(id: TMMemberID) -> Result<[TMProfileVO], Errors> {
        return .success(.mockData)
    }

}

// MARK: - Translater
extension UserUseCase {
    private func toVO(_ dto: TMProfileDTO) -> TMProfileVO {
        return TMProfileVO.mockData
    }
}
