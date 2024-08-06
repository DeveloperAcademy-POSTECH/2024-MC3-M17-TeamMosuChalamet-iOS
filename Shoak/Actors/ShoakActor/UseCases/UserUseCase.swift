import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

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

    #if canImport(UIKit)
    func uploadProfileImage(image: UIImage) async -> Result<TMProfileVO, NetworkError> {
        let compressionQuality: CGFloat = 0.1 // 압축 퀄리티. 0은 최저품질, 1은 최고품질
        guard let jpegData = image.jpegData(compressionQuality: compressionQuality) else {
            return .failure(.other("JPEG 데이터로 만들 수 없는 이미지입니다."))
        }
        let result = await userRepository.uploadProfileImage(data: jpegData)
        switch result {
        case .success(let dto):
            let vo = toVO(dto)
            return .success(vo)
        case .failure(let failure):
            return .failure(failure)
        }
    }
    #elseif canImport(AppKit)
    func uploadProfileImage(image: NSImage) async -> Result<TMProfileVO, NetworkError> {
        let compressionQuality: CGFloat = 0.1 // 압축 퀄리티. 0은 최저품질, 1은 최고품질
        guard let jpegData = image.jpegData(compressionQuality: compressionQuality) else {
            return .failure(.other("JPEG 데이터로 만들 수 없는 이미지입니다."))
        }
        let result = await userRepository.uploadProfileImage(data: jpegData)
        switch result {
        case .success(let dto):
            let vo = toVO(dto)
            return .success(vo)
        case .failure(let failure):
            return .failure(failure)
        }
    }
    #endif

    func deleteFriend(memberID: TMMemberID) async -> Result<Void, NetworkError> {
        let result = await userRepository.deleteFriend(memberID: memberID)
        return result
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
        TMProfileVO(id: dto.id, name: dto.name, imageURL: dto.imageURL)
    }
}
