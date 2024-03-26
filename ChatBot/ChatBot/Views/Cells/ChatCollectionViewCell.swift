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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
}

extension ChatCollectionViewCell {
    func configure() {
        contentView.addSubview(label)
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray.cgColor
        let inset = CGFloat(10)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
        ])
    }
    
    func updateContent(_ content: String) {
        label.text = content
    }
}
