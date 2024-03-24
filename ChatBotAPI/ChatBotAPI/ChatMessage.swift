//
//  Message.swift
//  ChatBot
//
//  Created by Janine on 1/4/24.
//

import Foundation

public struct ChatMessage: Codable, Hashable {
    public let role: ChatType
    public let content: String
    
    public init(role: ChatType, content: String) {
        self.role = role
        self.content = content
    }
}
