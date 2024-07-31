//
//  MessagesViewController.swift
//  InviteFriends
//
//  Created by KimYuBin on 7/28/24.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    private var imageView: UIImageView!
    private var nameLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var rejectButton: UIButton!
    private var acceptButton: UIButton!
    private var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()
    }
    
    // MARK: - Setup Subviews
    
    private func setupSubviews() {
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1)
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "이름테스트"
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        nameLabel.textColor = .black
        view.addSubview(nameLabel)
        
        descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = "님이 친구요청을 보냈습니다."
        descriptionLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        descriptionLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        view.addSubview(descriptionLabel)
        
        rejectButton = UIButton(type: .system)
        rejectButton.translatesAutoresizingMaskIntoConstraints = false
        rejectButton.setTitle("  거절하기", for: .normal)
        rejectButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        rejectButton.setTitleColor(UIColor(red: 0.918, green: 0.336, blue: 0.139, alpha: 1), for: .normal)
        rejectButton.layer.cornerRadius = 9
        rejectButton.layer.backgroundColor = UIColor.white.cgColor
        rejectButton.layer.borderWidth = 1
        rejectButton.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        rejectButton.clipsToBounds = true
        rejectButton.isHidden = true
        rejectButton.addTarget(self, action: #selector(handleRejectButton), for: .touchUpInside)
        rejectButton.setImage(UIImage(systemName: "person.fill.xmark")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 16)), for: .normal)
        rejectButton.tintColor = UIColor(red: 0.918, green: 0.336, blue: 0.139, alpha: 1)
        view.addSubview(rejectButton)
        
        acceptButton = UIButton(type: .system)
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        acceptButton.setTitle("  추가하기", for: .normal)
        acceptButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        acceptButton.setTitleColor(.black, for: .normal)
        acceptButton.layer.cornerRadius = 9
        acceptButton.layer.backgroundColor = UIColor(red: 1, green: 0.792, blue: 0, alpha: 1).cgColor
        acceptButton.layer.borderWidth = 1
        acceptButton.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        acceptButton.clipsToBounds = true
        acceptButton.isHidden = true
        acceptButton.addTarget(self, action: #selector(handleAcceptButton), for: .touchUpInside)
        acceptButton.setImage(UIImage(systemName: "person.fill.checkmark")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 16)), for: .normal)
        acceptButton.tintColor = .black
        view.addSubview(acceptButton)
        
        statusLabel = UILabel()
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.textColor = UIColor(red: 0.918, green: 0.336, blue: 0.139, alpha: 1)
        statusLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        statusLabel.textAlignment = .center
        statusLabel.isHidden = true
        statusLabel.layer.cornerRadius = 9
        statusLabel.layer.backgroundColor = UIColor.white.cgColor
        statusLabel.layer.borderWidth = 1
        statusLabel.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        statusLabel.clipsToBounds = true
        view.addSubview(statusLabel)
    }
    
    // MARK: - Setup Constraints
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 64),
            imageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 17),
            nameLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            descriptionLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            
            rejectButton.heightAnchor.constraint(equalToConstant: 38),
            rejectButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            rejectButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            rejectButton.trailingAnchor.constraint(equalTo: acceptButton.leadingAnchor, constant: -8),
            rejectButton.widthAnchor.constraint(equalTo: acceptButton.widthAnchor),
            rejectButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -16),
            
            acceptButton.heightAnchor.constraint(equalToConstant: 38),
            acceptButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            acceptButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            acceptButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -16),
            
            statusLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            statusLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            statusLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            statusLabel.heightAnchor.constraint(equalToConstant: 38)
        ])
    }
    
    // MARK: - Button Actions
    
    @objc private func handleRejectButton() {
        provideHapticFeedback()
        
        rejectButton.isHidden = true
        acceptButton.isHidden = true
        statusLabel.text = "친구 요청이 거절되었습니다"
        statusLabel.isHidden = false
    }
    
    @objc private func handleAcceptButton() {
        provideHapticFeedback()
        
        let message = MSMessage()
        
        let layout = MSMessageTemplateLayout()
        layout.caption = "친구 추가가 완료되었습니다!"
        layout.subcaption = "shoak://invite-success"  // URL 스킴을 포함한 링크 설정
        message.layout = layout
        
        if let conversation = activeConversation {
            conversation.insert(message) { error in
                if let error = error {
                    print("메시지 전송 오류: \(error.localizedDescription)")
                } else {
                    print("메시지 전송 성공")
                }
            }
        } else {
            print("활성화된 대화가 없습니다.")
        }
    }
    
    private func provideHapticFeedback() {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        super.willBecomeActive(with: conversation)
        // 현재 사용자가 받은 사람일 때만 버튼을 표시
        if let senderId = conversation.selectedMessage?.senderParticipantIdentifier,
           senderId != conversation.localParticipantIdentifier {
            acceptButton.isHidden = false
            rejectButton.isHidden = false
        }
    }
    
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        super.didReceive(message, conversation: conversation)
        // 메시지를 받은 경우의 추가 처리
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        super.didStartSending(message, conversation: conversation)
        // 메시지 전송 중 추가 처리
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        super.didCancelSending(message, conversation: conversation)
        // 메시지 전송 취소 시 추가 처리
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        super.willTransition(to: presentationStyle)
        // 프레젠테이션 스타일 변경 전 처리
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        super.didTransition(to: presentationStyle)
        // 프레젠테이션 스타일 변경 후 처리
    }
}
