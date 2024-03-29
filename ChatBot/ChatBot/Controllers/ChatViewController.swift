//
//  ChatViewController.swift
//  ChatBot
//
//  Created by Janine on 3/19/24.
//

import UIKit
import Combine
import ChatBotAPI

final class ChatViewController: UIViewController {
    
    // MARK: - Type
    private enum Section: CaseIterable {
        case main
    }
    
    // MARK: - Properties
    private let chatViewModel = ChatViewModel()
    private let input: PassthroughSubject<ChatViewModel.InputEvent, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    var chatCollectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, ChatMessage>!
    private var layout: UICollectionViewCompositionalLayout!

    private let button: UIButton = {
        let button = UIButton()
        
        button.layer.cornerRadius = 15
        button.contentMode = .scaleToFill
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.isEnabled = false
        
        let interfaceMode = UITraitCollection().userInterfaceStyle
        
        button.backgroundColor = interfaceMode == .dark ? .white : .orange
        button.setImage(UIImage(systemName: "paperplane.fill")!.withTintColor( interfaceMode == .dark ? .orange : .white, renderingMode: .alwaysOriginal), for: .normal)
        
        return button
    }()
    
    private let inputField: UITextView = {
        let textView = UITextView()
        
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 10
        textView.clipsToBounds = true
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        textView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        textView.isScrollEnabled = false
        
        return textView
    }()
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()

    private let vstack: UIStackView = {
        let stack = UIStackView()
        
        stack.axis = .vertical
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureBinding()
        configureNavigation()
        configureLayout()
        configureDataSource()
        textViewDidChange(inputField)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            button.backgroundColor = traitCollection.userInterfaceStyle == .dark ? .white : .orange
            button.setImage(UIImage(systemName: "paperplane.fill")!.withTintColor( traitCollection.userInterfaceStyle == .dark ? .orange : .white, renderingMode: .alwaysOriginal), for: .normal)
        }
    }
}


// MARK: - Configurations
private extension ChatViewController {
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ChatCollectionViewCell, ChatMessage> { cell, indexPath, item in
            
            cell.updateChatPosition(to: item.role == .user ? .right : .left)
            cell.updateContent(item.content)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: chatCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
    }
    
    func configureNavigation() {
        navigationItem.title = "Chat"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureBinding() {
        let output = chatViewModel.transform(input: input.eraseToAnyPublisher())
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .fetchRequestDidCreate:
                    self?.updateChatMessage()
                case .fetchChatDidStart(let isNetworking):
                    if isNetworking {
                        self?.updateChatMessage()
                    }
                case .fetchChatDidSucceed:
                    self?.updateChatMessage()
                case .fetchChatDidFail:
                    print("error")
                }
            }.store(in: &cancellables)
    }
    
    func configureLayout() {
        view.backgroundColor = .systemBackground
        
        let layout = createLayout()
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        
        vstack.addArrangedSubviews(UIView(), button)
        stack.addArrangedSubviews(inputField, vstack)
        view.addSubviews(collectionView, stack)
        
        inputField.delegate = self
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: stack.topAnchor, constant: -10),
            
            stack.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -12),
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stack.heightAnchor.constraint(lessThanOrEqualToConstant: 120),
            
            vstack.widthAnchor.constraint(equalToConstant: 32),
            button.heightAnchor.constraint(equalToConstant: 32),
        ])
        
        chatCollectionView = collectionView
    }
}

// MARK: - Functions
private extension ChatViewController {
    
    func updateChatMessage() {
        let messages = chatViewModel.messages
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, ChatMessage>()
        snapshot.appendSections([.main])
        snapshot.appendItems(messages)
        
        dataSource.apply(snapshot, animatingDifferences: true){ [weak self] in
            self?.scrollToBottom(animated: true)
        }
    }
    
    func scrollToBottom(animated: Bool) {
        let indexOfLastSection = max(0, chatCollectionView.numberOfSections - 1)
        let indexOfLastItem = max(0, chatCollectionView.numberOfItems(inSection: indexOfLastSection) - 1)
        let indexPath = IndexPath(item: indexOfLastItem, section: indexOfLastSection)
        
        guard indexOfLastSection >= 0, indexOfLastItem >= 0 else { return }
        
        chatCollectionView.scrollToItem(at: indexPath, at: .bottom, animated: animated)
    }
    
    func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            section.interGroupSpacing = 10
            
            return section
        }
    }
    
    @objc func sendButtonTapped() {
        if let text = inputField.text, !text.isEmpty {
            input.send(.sendButtonDidTap(prompt: text))
            inputField.text?.removeAll()
        }
    }
}

extension ChatViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)

        button.isEnabled = !textView.text.isEmpty
 
        if estimatedSize.height >= 120 {
            textView.isScrollEnabled = true
        } else {
            textView.isScrollEnabled = false
        }
    }
}



