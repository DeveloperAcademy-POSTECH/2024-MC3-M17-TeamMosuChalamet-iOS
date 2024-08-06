
import SwiftUI

struct SettingView: View {
    @Environment(NavigationManager.self) private var navigationManager
    @Environment(AccountManager.self) private var accountManager
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .center) {
                HStack {
                    BackButton {
                        navigationManager.setView(to: .friendList)
                    }
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
                            .padding(.leading, 15)
                        
                        Spacer()
                    }
                }
                .frame(height: 60)
                
                HStack(spacing: 0) {
                    Button {
                        
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
                
                HStack(spacing: 0) {
                    Button {
                        TokenManager.shared.deleteAllTokensWithoutDeviceToken()
                        navigationManager.setView(to: .login)
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
        .onAppear(){
            accountManager.refreshProfile()
        }
        .padding(.horizontal, 16)
    }
}

struct MyProfileView: View {
    @Environment(NavigationManager.self) private var navigationManager
    @Environment(AccountManager.self) private var accountManager
    
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
                
                Text(accountManager.profile?.name ?? "쇽")
                    .font(.textTitle)
                    .foregroundStyle(Color.textBlack)
                    .padding(.leading, 21)
                
                Spacer()
            }
            .padding(7)
            
            Button {
                navigationManager.setView(to: .editProfile)
            } label: {
                HStack(alignment: .center, spacing: 10) {
                    styledIcon(named: "pencil.line")
                    
                    Text("수정하기")
                        .font(.textButton)
                        .foregroundStyle(Color.textBlack)
                }
                .padding(.horizontal, 41)
                .padding(.vertical, 14)
                .frame(width: 345, alignment: .center)
                .background(Color.shoakWhite)
                .cornerRadius(9)
                .overlay(
                    RoundedRectangle(cornerRadius: 9)
                        .strokeBorder(Color.strokeBlack, lineWidth: 1)
                )
            }
            .padding(.top, 6)
        }
        .padding(8)
        .background(Color.shoakWhite)
        .cornerRadius(17)
        .overlay(
            RoundedRectangle(cornerRadius: 17)
                .strokeBorder(Color.strokeBlack, lineWidth: 1)
        )
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
}
