//
//  ChatCollectionViewCell.swift
//  ChatBot
//
//  Created by Janine on 3/24/24.
//

import UIKit

final class ChatCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "chat-cell-identifier"
    
    enum Position {
        case left
        case right
    }
    
    private var activeConstraints: [NSLayoutConstraint] = []
    
    private let label: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .white
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        
        return label
    }()
    
    private let bubble: UIView = {
        let bubble = UIView()
        
        bubble.layer.cornerRadius = 10
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        label.text = nil
        NSLayoutConstraint.deactivate(activeConstraints)
        activeConstraints.removeAll()
    }
}

extension ChatCollectionViewCell {
    private func configure() {
        contentView.addSubviews(bubble, label)
        
        let inset = CGFloat(10)
        
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(lessThanOrEqualTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.66),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
            
            bubble.topAnchor.constraint(equalTo: label.topAnchor, constant: -inset),
            bubble.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: inset),
            bubble.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: -inset),
            bubble.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: inset)
        ])
    }
    
    func updateChatPosition(to position: Position) {
        var constraint: [NSLayoutConstraint] = []
        
        switch position {
        case .left:
            bubble.backgroundColor = .systemGreen
            constraint += [label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)]
        case .right:
            bubble.backgroundColor = .systemBlue
            constraint += [label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)]
        }
        NSLayoutConstraint.activate(constraint)
        activeConstraints = constraint
    }
    
    func updateContent(_ content: String) {
        label.text = content
    }
}
