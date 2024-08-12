//
//  EditProfileView.swift
//  Shoak
//
//  Created by KimYuBin on 8/5/24.
//

import SwiftUI
import Photos

struct IdentifiableImage: Identifiable, Equatable {
    let id = UUID()
    var image: UIImage
    var asset: PHAsset // PHAsset을 포함시켜서 나중에 고품질 이미지를 요청할 때 사용

    // Equatable 프로토콜 구현 (이미지 비교를 위해)
    static func == (lhs: IdentifiableImage, rhs: IdentifiableImage) -> Bool {
        return lhs.id == rhs.id
    }
}

struct EditProfileView: View {
    @Environment(AccountManager.self) private var accountManager
    @Environment(NavigationManager.self) private var navigationManager
    @StateObject private var photoManager = PhotoManager()
    @State private var selectedImage: IdentifiableImage? = nil
    @State private var alertMessage = ""
    
    var body: some View {
        GeometryReader { geometry in
            let spacing: CGFloat = 4
            let sidePadding: CGFloat = 8
            let imageSize = (geometry.size.width - sidePadding * 2 - spacing * 2) / 3
            
            VStack(spacing: 0) {
                ZStack(alignment: .center) {
                    HStack {
                        BackButton()
                            .frame(maxHeight: 44)

                        Spacer()
                    }
                    
                    Text("프로필 수정")
                        .font(.textPageTitle)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
                
                if photoManager.images.isEmpty {
                    VStack {
                        Spacer()
                        
                        Text("앨범 접근 권한을 확인해 주세요.")
                            .padding()
                        
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVGrid(
                            columns: Array(repeating: GridItem(.flexible(), spacing: spacing), count: 3),
                            spacing: spacing
                        ) {
                            ForEach(photoManager.images) { identifiableImage in
                                Button(action: {
                                    selectedImage = identifiableImage
                                }) {
                                    Image(uiImage: identifiableImage.image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: imageSize, height: imageSize)
                                        .clipped()
                                }
                                .task {
                                    if let image = await photoManager.fetchHighQualityImage(for: identifiableImage),
                                       let index = self.photoManager.images.firstIndex(where: { $0.id == identifiableImage.id }) {
                                        print("index : \(index)")
                                        DispatchQueue.main.async {
                                            self.photoManager.images[index].image = image
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, sidePadding)
                        .padding(.vertical, 8)
                    }
                }
            }
            .fullScreenCover(item: $selectedImage) { identifiableImage in
                PhotoDetailView(
                    image: identifiableImage.image,
                    navigationManager: navigationManager,
                    onCancel: {
                        selectedImage = nil
                    },
                    onSave: { updatedImage in
                        Task {
                            let result = await accountManager.updateProfileImage(updatedImage)
                            
                            switch result {
                            case .success:
                                alertMessage = "프로필 이미지가 성공적으로 업데이트되었습니다."
                            case .failure(let error):
                                alertMessage = "프로필 이미지 업데이트 실패: \(error.localizedDescription)"
                            }
                            selectedImage = nil
                            navigationManager.setPrevView()
                        }
                    }
                )
            }
            .task {
                await checkPhotoLibraryPermission()
            }
        }
    }
    
    private func checkPhotoLibraryPermission() async {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .notDetermined:
            await withCheckedContinuation { continuation in
                PHPhotoLibrary.requestAuthorization { newStatus in
                    if newStatus == .authorized {
                        Task {
                            await photoManager.fetchPhotosFastFormat()
                        }
                    }
                    continuation.resume()
                }
            }
        case .restricted, .denied:
            print("권한이 없습니다.")
        case .authorized, .limited:
            Task {
                await photoManager.fetchPhotosFastFormat()
            }
        @unknown default:
            fatalError("알 수 없는 권한 상태입니다.")
        }
    }
}

struct PhotoDetailView: View {
    let image: UIImage
    let navigationManager: NavigationManager
    let onCancel: () -> Void
    let onSave: (UIImage) -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 361, height: 361)
                .cornerRadius(100)
                .padding()
            
            Spacer()
            
            HStack {
                Button(action: onCancel) {
                    HStack {
                        Image(systemName: "xmark")
                            .font(.icon)
                        
                        Text("취소")
                            .font(.textButton)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 17)
                    .foregroundStyle(Color.textWhite)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .inset(by: 0.5)
                            .stroke(Color.strokeWhite, lineWidth: 1)
                    )
                }
                
                Spacer()
                
                Button(action: { onSave(image) }) {
                    HStack {
                        Text("저장")
                            .font(.textButton)
                        
                        Image(systemName: "square.and.arrow.up")
                            .font(.icon)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .foregroundStyle(Color.textBlack)
                    .background(Color.shoakYellow)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .inset(by: 0.5)
                            .stroke(Color.strokeBlack, lineWidth: 1)
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .background(Color.bgBlack.edgesIgnoringSafeArea(.all))
    }
}

class PhotoManager: ObservableObject {
    @Published var images: [IdentifiableImage] = []
    
    func fetchPhotosFastFormat() async {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        let imageManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = false
        requestOptions.deliveryMode = .fastFormat // 빠른 포맷으로 이미지 요청
        requestOptions.resizeMode = .exact

        await withCheckedContinuation { continuation in
            let group = DispatchGroup()
            for index in 0..<fetchResult.count {
                group.enter()
                let asset = fetchResult.object(at: index)
                let targetSize = CGSize(width: 500, height: 500)

                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: requestOptions) { image, _ in
                    if let image = image {
                        DispatchQueue.main.async {
                            self.images.append(IdentifiableImage(image: image, asset: asset))
                            group.leave()
                        }
                    } else {
                        group.leave()
                    }
                }
            }
            group.notify(queue: .main) {
                continuation.resume()
            }
        }
    }

    func fetchHighQualityImage(for identifiableImage: IdentifiableImage) async -> UIImage? {
        let asset = identifiableImage.asset
        let imageManager = PHImageManager.default()
        let targetSize = CGSize(width: 500, height: 500)
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = false
        requestOptions.deliveryMode = .highQualityFormat // 고품질 포맷으로 이미지 요청
        requestOptions.resizeMode = .exact

        return await withCheckedContinuation { continuation in
            imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: requestOptions) { image, _ in
                if let image {
                    continuation.resume(returning: image)
                    return
                } else {
                    continuation.resume(returning: nil)
                    return
                }
            }
        }
    }
}
