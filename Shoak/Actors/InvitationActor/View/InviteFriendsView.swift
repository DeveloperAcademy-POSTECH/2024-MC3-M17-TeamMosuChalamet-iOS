//
//  InviteFriendsView.swift
//  Shoak
//
//  Created by KimYuBin on 7/30/24.
//

import SwiftUI
import MessageUI
import CoreImage.CIFilterBuiltins

struct InviteFriendsView: View {

    
    @Environment(InvitationManager.self) private var invitationManager
    @Environment(AccountManager.self) private var accountManager

    @State private var isShowingQR: Bool = false

    var body: some View {
        VStack(spacing: 16) {
            TopButtons()

            MyProfileView(isShowEditProfileButton: false)

            SendButton()

            QRButton(isShowingQR: $isShowingQR)

            if isShowingQR {
                QRView()
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .onAppear {
            accountManager.refreshProfile()
        }
    }

    struct TopButtons: View {
        @Environment(NavigationManager.self) private var navigationManager
        var body: some View {
            ZStack(alignment: .center) {
                HStack {
                    BackButton()
                        .frame(maxHeight: 44)

                    Spacer()
                }

                Text("친구추가")
                    .font(.textPageTitle)
            }
        }
    }

    struct SendButton: View {
        @Environment(AccountManager.self) private var accountManager
        @State private var showMessageCompose = false
        @State private var showAlert = false
        @State private var alertMessage = ""
        var body: some View {
            Button {
                if MFMessageComposeViewController.canSendText() {
                    showMessageCompose = true
                } else {
                    alertMessage = "이 장치는 문자 메시지를 보낼 수 없습니다."
                    showAlert = true
                }
            } label: {
                HStack(alignment: .center, spacing: 10) {
                    Image(systemName: "paperplane.fill")
                        .font(.icon)

                    Text("메세지로 초대하기")
                        .font(.textButton)
                }
            }
            .buttonStyle(FilledButtonStyle())
            .alert(isPresented: $showAlert) {
                Alert(title: Text("에러"), message: Text(alertMessage), dismissButton: .default(Text("확인")))
            }
            .sheet(isPresented: $showMessageCompose) {
                if let profile = accountManager.profile {
                    MessageComposeView(isPresented: $showMessageCompose, profile: profile)
                } else {
                    Text("프로필을 불러올 수 없습니다. 다시 시도해주세요.")
                }
            }
        }
    }

    struct QRButton: View {
        @Binding var isShowingQR: Bool
        var body: some View {
            Button {
                withAnimation {
                    isShowingQR.toggle()
                }
            } label: {
                HStack(alignment: .center, spacing: 10) {
                    Image(systemName: "qrcode")
                        .font(.icon)

                    Text("QR로 초대하기")
                        .font(.textButton)
                }
            }
            .buttonStyle(FilledButtonStyle())
        }
    }

    struct QRView: View {
        @Environment(AccountManager.self) private var accountManager
        @State private var qrImage: UIImage?
        var body: some View {
            Group {
                if let qrImage {
                    HStack(spacing: 16) {
                        Image(uiImage: qrImage)
                            .onDrag {
                                let provider = NSItemProvider(object: qrImage)
                                return provider
                            }

                        ShareLink(item: Image(uiImage: qrImage), preview: SharePreview("친구 추가 QR", image: Image(uiImage: qrImage)))
                            .buttonStyle(FilledButtonStyle())
                    }
                } else {
                    ProgressView()
                }
            }
            .padding()
            .shadow(radius: 5)
            .onAppear {
                withAnimation {
                    self.qrImage = makeQR()
                }
            }
        }

        private func makeQR() -> UIImage? {
            // 이미지 렌더링을 처리하는 부분
            let context = CIContext()
            // QR 코드 생성기 필터
            let filter = CIFilter.qrCodeGenerator()
            // QR 데이터 생성해주기.
            guard let id = accountManager.profile?.id else {
                return nil
            }
            let qrData = "https://shoak.mosu.blog/invite?memberID=\(id)"
            // 필터에 원하는 Text를 넣어줍니다.
            filter.setValue(qrData.data(using: .utf8), forKey: "inputMessage")

            if let qrCodeImage = filter.outputImage {
                let transform = CGAffineTransform(scaleX: 5, y: 5)
                let scaledCIImage = qrCodeImage.transformed(by: transform)
                if let qrCodeCGImage = context.createCGImage(scaledCIImage, from: scaledCIImage.extent) {
                    // Image에 바로 넣을 수 있도록 UIImage로 변환해줍니다.
                    return UIImage(cgImage: qrCodeCGImage)
                }
            }
            return nil
        }
    }
}

#Preview {
    InviteFriendsView()
        .addEnvironmentsForPreview()
}
