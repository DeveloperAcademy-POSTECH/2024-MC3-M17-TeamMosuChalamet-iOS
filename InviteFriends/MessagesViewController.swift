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
    
    private var imageView: UIImageView!
    private var nameLabel: UILabel!
    private var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()
    }
    
    // MARK: - Setup Subviews
    
    private func setupSubviews() {
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
        
        descriptionLabel = UILabel()
        descriptionLabel.text = "님이 친구요청을 보냈습니다."
        descriptionLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        descriptionLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        view.addSubview(descriptionLabel)
    }
    
    // MARK: - Setup Constraints
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(safeArea).offset(64)
            make.centerX.equalTo(safeArea)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(17)
            make.centerX.equalTo(safeArea)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.centerX.equalTo(safeArea)
        }
    }
    
    // MARK: - Button Action
    
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
