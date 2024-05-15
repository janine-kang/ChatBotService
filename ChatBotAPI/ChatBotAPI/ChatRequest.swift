//
//  APIRequest.swift
//  ChatBot
//
//  Created by Janine on 1/4/24.
//

import Foundation

public struct ChatRequest: Encodable {
    public let model: String
    public let stream: Bool
    public let messages: [ChatMessage]
    
    public init(model: String, stream: Bool, messages: [ChatMessage]) {
        self.model = model
        self.stream = stream
        self.messages = messages
    }
}

