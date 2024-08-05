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
    private var acceptButton: UIButton!
    private var statusLabel: UILabel!
    var id: TMMemberID

    init(_ id: TMMemberID) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
        descriptionLabel.text = "\(id)님이 친구요청을 보냈습니다."
        descriptionLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        descriptionLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        view.addSubview(descriptionLabel)
        
        acceptButton = UIButton(type: .system)
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        acceptButton.setTitle("  앱 열어서 수락하기", for: .normal)
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
    
    @objc private func handleAcceptButton() {
        provideHapticFeedback()

        if let url = URL(string: "shoak://invite?id=123123") {
            self.extensionContext?.open(url, completionHandler: nil)
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
