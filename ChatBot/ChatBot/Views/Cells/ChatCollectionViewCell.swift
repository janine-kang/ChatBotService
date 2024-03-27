//
//  ChatCollectionViewCell.swift
//  ChatBot
//
//  Created by Janine on 3/24/24.
//

import UIKit

final class ChatCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "chat-cell-identifier"

    private let label: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        
        return label
    }()
    
    private let bubble: UIView = {
        let bubble = UIView()
        
        bubble.layer.cornerRadius = 10
        bubble.backgroundColor = .systemBlue
        bubble.translatesAutoresizingMaskIntoConstraints = false
        
        return bubble
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
}

extension ChatCollectionViewCell {
    private func configure() {
        contentView.addSubviews(bubble, label)
        
        let inset = CGFloat(10)
        
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(lessThanOrEqualToConstant: 300),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
            
            bubble.topAnchor.constraint(equalTo: label.topAnchor, constant: -inset),
            bubble.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: inset),
            bubble.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: -inset),
            bubble.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: inset)
        ])
    }
    
    func updateContent(_ content: String) {
        label.text = content
    }
}
