import Foundation

final class UserUseCase {
    let userRepository: UserRepository

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    func getProfile(id: TMMemberID) -> Result<TMProfileVO, Errors> {
        let serverData: TMProfileDTO = .mockData // 서버 통신 후 가져온 DTO
        return .success(toVO(serverData)) // VO를 리턴
    }

    func getFriends() async -> Result<[TMProfileVO], NetworkError> {
        let result = await userRepository.getFriends()
        switch result {
        case .success(let dto):
            let vo = dto.map(toVO)
            return .success(vo)
        case .failure(let failure):
            return .failure(failure)
        }
    }
}

// MARK: - Translater
extension UserUseCase {
    private func toVO(_ dto: TMProfileDTO) -> TMProfileVO {
        TMProfileVO(
            memberID: dto.id,
            imageURLString: dto.imageURL,
            name: dto.name
        )
    }
}
