
import Foundation

class ShoakUseCase {
    func getUser(id: TMMemberID) -> TMProfileVO {
        let serverData: TMProfileDTO = .mockData // 서버 통신 후 가져온 DTO
        return translate(serverData) // VO를 리턴
    }

    private func translate(_ dto: TMProfileDTO) -> TMProfileVO {
        return TMProfileVO(
            memberID: dto.memberID,
            name: dto.name
        )
    }
}
