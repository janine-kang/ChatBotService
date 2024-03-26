//
//  Constants.swift
//  ChatBot
//
//  Created by Janine on 1/5/24.
//

import Foundation
import ChatBotAPI

enum ConstantsForNetworkRequest {
    static let model = "gpt-3.5-turbo-1106"
    static let defaultMessage = ChatMessage(
        role: .system,
        content: "You are an assistant that occasionally misspells words"
    )
}
