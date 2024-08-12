import SwiftUI

struct SettingView: View {
    @Environment(NavigationManager.self) private var navigationManager
    @Environment(AccountManager.self) private var accountManager
    @State private var showDeleteAccountAlert = false

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .center) {
                HStack {
                    BackButton()
                        .frame(maxHeight: 44)

                    Spacer()
                }
                
                Text("설정")
                    .font(.textPageTitle)
            }
            
            MyProfileView()
                .padding(.top, 23)
            
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Button {
                        navigationManager.setView(to: .deleteFriends)
                    } label: {
                        styledIcon(named: "person.fill.badge.minus")
                            .padding(.leading, 18)
                        
                        Text("친구 삭제")
                            .font(.textButton)
                            .foregroundStyle(Color.textBlack)
                            .padding(.leading, 14)
                        
                        Spacer()
                    }
                }
                .frame(height: 60)
#if !APPCLIP
                HStack(spacing: 0) {
                    Button {
                        navigationManager.setView(to: .onboarding)
                    } label: {
                        styledIcon(named: "questionmark.circle.fill")
                            .padding(.leading, 18)
                        
                        Text("도움말")
                            .font(.textButton)
                            .foregroundStyle(Color.textBlack)
                            .padding(.leading, 13)
                        
                        Spacer()
                    }
                    
                }
                .frame(height: 60)
#endif
                HStack(spacing: 0) {
                    Button {
                        accountManager.logout()
                        navigationManager.setView(to: .login, saveHistory: false)
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundStyle(Color.shoakRed)
                            .font(.icon)
                            .padding(.leading, 18)
                        
                        Text("로그아웃")
                            .font(.textButton)
                            .foregroundStyle(Color.shoakRed)
                            .padding(.leading, 9)
                        
                        Spacer()
                    }
                }
                .frame(height: 60)
                
                HStack(spacing: 0) {
                    Button {
                        showDeleteAccountAlert = true
                    } label: {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(Color.shoakRed)
                            .font(.icon)
                            .padding(.leading, 18)
                        
                        Text("탈퇴하기")
                            .font(.textButton)
                            .foregroundStyle(Color.shoakRed)
                            .padding(.leading, 13)
                        
                        Spacer()
                    }
                }
                .frame(height: 60)
                .alert(isPresented: $showDeleteAccountAlert) {
                    Alert(
                        title: Text("탈퇴하시겠습니까?"),
                        message: Text("탈퇴하면 모든 데이터가 삭제됩니다."),
                        primaryButton: .destructive(Text("탈퇴")) {
                            Task {
                                if case .success = await accountManager.signOut() {
                                    navigationManager.setView(to: .login, saveHistory: false)
                                } else {
                                    print("탈퇴 실패..")
                                    // TODO: 실패해도 login으로 가는거 빼기
                                }
                            }
                        },
                        secondaryButton: .cancel(Text("취소"))
                    )
                }
            }
            .background(Color.shoakWhite)
            .cornerRadius(17)
            .overlay(
                RoundedRectangle(cornerRadius: 17)
                    .strokeBorder(Color.strokeBlack, lineWidth: 1)
            )
            .padding(.top, 5)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .onAppear() {
            accountManager.refreshProfile()
        }
    }
}


struct MyProfileView: View {
    @Environment(NavigationManager.self) private var navigationManager
    @Environment(AccountManager.self) private var accountManager

    var isShowEditProfileButton: Bool = true
    @State private var isShowChangeNameAlert = false
    @State private var name = ""

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0){
                styledIcon(named: "person.circle.fill")
                
                Text("내 프로필")
                    .font(.textBody)
                    .foregroundStyle(Color.textBlack)
                    .padding(.leading, 6)
                
                Spacer()
            }
            .padding(10)
            
            Divider()
                .padding(.vertical, 6)
            
            HStack {
                Group {
                    if let imageURLString = accountManager.profile?.imageURL,
                       let imageURL = URL(string: imageURLString) {
                        AsyncImage(url: imageURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .clipShapeBorder(RoundedRectangle(cornerRadius: 30), Color.strokeGray, 1.0)
                                .padding(.leading, 7)
                        } placeholder: {
                            ProgressView()
                                .frame(width: 80, height: 80)
                                .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                                .cornerRadius(30)
                                .padding(.leading, 7)
                        }
                    } else {
                        Image(.defaultProfile)
                            .resizable()
                            .frame(width: 80, height: 80)
                            .clipShapeBorder(RoundedRectangle(cornerRadius: 30), Color.strokeGray, 1.0)
                            .padding(.leading, 7)
                    }
                }
                .overlay(alignment: .bottomTrailing) {
                    Button {
                        navigationManager.setView(to: .editProfile)
                    } label: {
                        Image(systemName: "photo.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                    }
                    .padding(4)
                    .background(Color.bgGray)
                    .clipShapeBorder(Circle(), Color.strokeBlack, 1)
                    .shadow(radius: 4)
                    .buttonStyle(.plain)
                }

                Text(accountManager.profile?.name ?? "(이름 없음)")
                    .font(.textTitle)
                    .foregroundStyle(Color.textBlack)
                    .padding(.leading, 21)
                    .onTapGesture {
                        self.name = accountManager.profile?.name ?? ""
                        self.isShowChangeNameAlert.toggle()
                    }

                Spacer()
            }
            .padding(7)

            if isShowEditProfileButton {
                Button {
                    self.name = accountManager.profile?.name ?? ""
                    self.isShowChangeNameAlert.toggle()
                } label: {
                    HStack(alignment: .center, spacing: 10) {
                        styledIcon(named: "pencil.line")

                        Text("이름 수정하기")
                            .font(.textButton)
                    }
                }
                .buttonStyle(FilledButtonStyle())
                .padding(.top, 6)
            }
        }
        .padding(8)
        .background(Color.shoakWhite)
        .cornerRadius(17)
        .overlay(
            RoundedRectangle(cornerRadius: 17)
                .strokeBorder(Color.strokeBlack, lineWidth: 1)
        )
        .alert("이름 수정", isPresented: $isShowChangeNameAlert) {
            TextField((accountManager.profile?.name ?? "") + "(최대 8글자)", text: $name)
            Button("취소", role: .cancel) {}
            Button("이름 바꾸기") {
                Task {
                    guard name.count <= 8 && !name.isEmpty else { return }
                    if case .success = await accountManager.changeName(name) {
                        await accountManager.getProfile()
                    }
                }
            }
        } message: {
            Text("수정할 이름을 입력해주세요 (최대 8글자)")
        }
        .task {
            await accountManager.getProfile()
        }
    }
}

extension View {
    func styledIcon(named systemName: String, color: Color = .textBlack, fontSize: Font = .icon) -> some View {
        Image(systemName: systemName)
            .foregroundStyle(color)
            .font(fontSize)
    }
}

#Preview {
    SettingView()
        .addEnvironmentsForPreview()
}
