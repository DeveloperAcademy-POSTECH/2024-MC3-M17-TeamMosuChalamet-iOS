import Foundation

final class UserUseCase {
    let userRepository: UserRepository

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    func getProfile() async -> Result<TMProfileVO, NetworkError> {
        let result = await userRepository.getProfile()
        switch result {
        case .success(let dto):
            let vo = toVO(dto)
            return .success(vo)
        case .failure(let failure):
            return .failure(failure)
        }
    }

    func getFriends() async -> Result<[TMFriendVO], NetworkError> {
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
    private func toVO(_ dto: TMFriendDTO) -> TMFriendVO {
        TMFriendVO(
            memberID: dto.id,
            imageURLString: dto.imageURL,
            name: dto.name
        )
    }

    private func toVO(_ dto: TMProfileDTO) -> TMProfileVO {
        TMProfileVO(name: dto.name, imageURL: dto.imageURL)
    }
}
