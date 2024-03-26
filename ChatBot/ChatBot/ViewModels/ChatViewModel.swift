//
//  ChatViewModel.swift
//  ChatBot
//
//  Created by Janine on 1/15/24.
//

import Foundation
import Combine
import ChatBotAPI

final class ChatViewModel {
    enum InputEvent {
        case sendButtonDidTap(prompt: String)
    }
    
    enum Output {
        case fetchRequestDidCreate
        case fetchChatDidStart(isNetworking: Bool)
        case fetchChatDidSucceed
        case fetchChatDidFail
    }
    
    private(set) var messages: [ChatMessage]
    private var cancellables = Set<AnyCancellable>()
    private let output: PassthroughSubject<Output, Never> = .init()
    
    private(set) var isNetworking = false
    
    // MARK: - Life cycle
    init(messages: [ChatMessage] = []) {
        self.messages = messages
    }
    
    func transform(input: AnyPublisher<InputEvent, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .sendButtonDidTap(let prompt):
                self?.handleRequest(with: prompt)
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func handleMessage(prompt: String, from role: ChatType) {
        messages.append(ChatMessage(role: role, content: prompt))
    }
    
    private func handleRequest(with prompt: String) {
        messages.append(ChatMessage(role: .user, content: prompt))
        
        let builder = PostChatBotNetworkBuilder(message: messages.compactMap({ $0 }))
        guard let request = try? APIService.shared.makeRequest(builder) else { return }
        
        output.send(.fetchRequestDidCreate)
        
        Task(priority: .background) {
            isNetworking = true
            output.send(.fetchChatDidStart(isNetworking: isNetworking))
            
            let data: Result<ChatResponse, Error> = try await APIService.shared.execute(request: request)
            
            isNetworking = false
            guard case .success(let response) = data else {
                output.send(.fetchChatDidFail)
                return
            }
            let content = response.choices[0].message.content
            messages.append(ChatMessage(role: .assistant, content: content))
            
            output.send(.fetchChatDidSucceed)
        }
    }
    
    // MARK: - Public
    func getMessage(at index: Int) -> ChatMessage? {
        messages[safeIndex: index]
    }
    
    func getChatMessageCount() -> Int {
        isNetworking ? messages.count + 1 : messages.count
    }
}
