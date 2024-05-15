//
//  PostChatBotNetworkBuilder.swift
//  ChatBot
//
//  Created by Janine on 1/5/24.
//

import Foundation
import ChatBotAPI

struct PostChatBotNetworkBuilder: NetworkRequestBuildable {
    typealias RequestBody = ChatRequest
    
    var httpMethod: HttpMethod = .post
    let authKey: String? = Environment.apiKey
    var body: RequestBody
    
    var path: String
    
    init(message: [ChatMessage]) {
        self.path = "v1/chat/\(Endpoint.completions.rawValue)"
        self.body = ChatRequest(
            model: ConstantsForNetworkRequest.model,
            stream: false,
            messages: message
        )
    }
}
