//
//  InvitationViewController.swift
//  InviteFriends
//
//  Created by 정종인 on 8/5/24.
//

import UIKit

class InvitationViewController: UIViewController {
    private var imageView: UIImageView!
    private var nameLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var acceptButton: UIButton!
    private var statusLabel: UILabel!

    var messageURL: URL? = nil
    var profile: TMProfileVO? = nil {
        didSet {
            self.loadViewIfNeeded()
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
        nameLabel.text = self.profile?.name ?? "이름 로딩중.."
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        nameLabel.textColor = .black
        view.addSubview(nameLabel)

        descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = "님이 친구요청을 보냈습니다."
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
        acceptButton.isHidden = false
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


        // 프로필 이미지 세팅
        guard let imageURLString = profile?.imageURL,
        let imageURL = URL(string: imageURLString) else { return }

        let task = URLSession.shared.dataTask(with: imageURL) { [weak self] data, response, error in
            // 에러가 있거나, 데이터가 없으면 리턴
            guard let self = self, let data = data, error == nil else {
                return
            }

            // HTTP 응답 상태 코드 확인
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                // 받은 데이터를 UIImage로 변환
                let image = UIImage(data: data)

                // UI 업데이트는 메인 스레드에서 실행
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }

        // 네트워크 요청 실행
        task.resume()
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
            acceptButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
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

        print("messageURL: \(String(describing: messageURL))")
        print("profile : \(String(describing: profile))")

        if let url = messageURL {
            self.extensionContext?.open(url, completionHandler: nil)
        }
    }

    private func provideHapticFeedback() {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
    }
}
