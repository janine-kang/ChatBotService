//
//  ChatMessageCell.swift
//  ChatBot
//
//  Created by 동준 on 1/16/24.
//

import UIKit

final class ChatMessageCell: UICollectionViewCell {
    
    static let identifier = "chat-message-cell"
    
    private var chatBotBubbleConstarint: [NSLayoutConstraint] = []
    private var userBubbleConstraint: [NSLayoutConstraint] = []
    
    private lazy var containerView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        view.layer.cornerRadius = 4
        view.addSubview(chatLabel)
        view.addSubview(bubbleTail)
        
        return view
    }()
    
    private lazy var bubbleTail: ChatBubbleTail = {
        var tail = ChatBubbleTail(frame: CGRect(x: 0, y: 0, width: 15, height: 10))
        tail.translatesAutoresizingMaskIntoConstraints = false
        tail.backgroundColor = .clear
        
        return tail
        
    }()
    
    private lazy var chatLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init-error")
    }
    
    // MARK: - methods
    private func setupView() {
        contentView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.8),
            
            chatLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            chatLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            chatLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            chatLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            
            bubbleTail.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            bubbleTail.widthAnchor.constraint(equalToConstant: 15),
            bubbleTail.heightAnchor.constraint(equalToConstant: 10),
        ])
    }
    
    func configure(model: ChatViewModel, index: Int) {
        guard let message = model.getMessage(at: index) else { return }
        let content = message.content
        chatLabel.text = content
        
        switch message.role {
        case .assistant:
            configureChatBotBubble()
        case .user:
            configureUserBubble()
        default:
            break
        }
    }
    
    private func configureChatBotBubble() {
        chatBotBubbleConstarint = [
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bubbleTail.trailingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 3)
        ]
        containerView.backgroundColor = .darkGray
        bubbleTail.color = .darkGray
        bubbleTail.transform = CGAffineTransform(scaleX: -1, y: 1)
        chatLabel.textColor = .white
        
        NSLayoutConstraint.activate(chatBotBubbleConstarint)
    }
    
    private func configureUserBubble() {
        userBubbleConstraint = [
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bubbleTail.leadingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -3)
        ]
        containerView.backgroundColor = .systemRed
        bubbleTail.color = .systemRed
        bubbleTail.transform = CGAffineTransform(scaleX: 1, y: 1)
        chatLabel.textColor = .black
        
        NSLayoutConstraint.activate(userBubbleConstraint)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        NSLayoutConstraint.deactivate(chatBotBubbleConstarint + userBubbleConstraint)
        layoutIfNeeded()
    }
}
