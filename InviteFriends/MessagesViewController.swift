//
//  MessagesViewController.swift
//  InviteFriends
//
//  Created by KimYuBin on 7/28/24.
//

import UIKit
import SnapKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    
    private var profileIcon: UIImageView!
    private var profileLabel: UILabel!
    private var separatorView: UIView!
    private var imageView: UIImageView!
    private var nameLabel: UILabel!
    private var shareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()
    }
    
    // MARK: - Setup Subviews
    
    private func setupSubviews() {
        profileIcon = UIImageView()
        profileIcon.image = UIImage(systemName: "person.circle.fill")
        profileIcon.tintColor = .black
        profileIcon.contentMode = .scaleAspectFit
        view.addSubview(profileIcon)
        
        profileLabel = UILabel()
        profileLabel.text = "내 프로필"
        profileLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        profileLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        view.addSubview(profileLabel)
        
        separatorView = UIView()
        separatorView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        view.addSubview(separatorView)
        
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1)
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        
        nameLabel = UILabel()
        nameLabel.text = "이름테스트"
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        nameLabel.textColor = .black
        view.addSubview(nameLabel)
        
        shareButton = UIButton(type: .system)
        shareButton.setTitle("  공유하기", for: .normal)
        shareButton.setTitleColor(.black, for: .normal)
        shareButton.backgroundColor = .systemYellow
        shareButton.layer.cornerRadius = 9
        shareButton.tintColor = .black
        
        let shareIcon = UIImage(systemName: "paperplane.fill")
        shareButton.setImage(shareIcon, for: .normal)
        shareButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        view.addSubview(shareButton)
    }
    
    // MARK: - Setup Constraints
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        profileIcon.snp.makeConstraints { make in
            make.top.equalTo(safeArea).offset(64)
            make.leading.equalTo(safeArea).offset(8)
            make.width.height.equalTo(24)
        }
        
        profileLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileIcon)
            make.leading.equalTo(profileIcon.snp.trailing).offset(8)
        }
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(profileLabel.snp.bottom).offset(16)
            make.leading.trailing.equalTo(safeArea).inset(8)
            make.height.equalTo(1)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(16)
            make.centerX.equalTo(safeArea)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.centerX.equalTo(safeArea)
        }
        
        shareButton.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(16)
            make.leading.trailing.equalTo(safeArea).inset(8)
            make.height.equalTo(44)
        }
    }
    
    // MARK: - Button Action
    
    @objc private func shareButtonTapped() {
        print("공유하기 버튼 탭")
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        // iMessage 확장이 활성화될 때 실행될 코드
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // iMessage 확장이 비활성화될 때 실행될 코드
    }
    
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // 다른 기기에서 생성된 메시지를 받을 때 실행될 코드
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // 사용자가 전송 버튼을 탭할 때 실행될 코드
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // 사용자가 메시지를 전송하지 않고 삭제할 때 실행될 코드
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // 확장이 새로운 프레젠테이션 스타일로 전환되기 전에 실행될 코드
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // 확장이 새로운 프레젠테이션 스타일로 전환된 후에 실행될 코드
    }
}
