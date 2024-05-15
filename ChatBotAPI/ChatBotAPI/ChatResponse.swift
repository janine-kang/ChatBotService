//
//  APIResponse.swift
//  ChatBot
//
//  Created by 동준 on 1/4/24.
//

import Foundation

public struct ChatResponse: Decodable {
    let id: String
    let object: String
    let created: Date
    let model: String
    let systemFingerprint: String
    public let choices: [Choice]
    let usage: Usage
    
    private enum CodingKeys: String, CodingKey {
        case id, object, created, model, choices, usage
        case systemFingerprint = "system_fingerprint"
    }
    
    public init(id: String, object: String, created: Date, model: String, systemFingerprint: String, choices: [Choice], usage: Usage) {
        self.id = id
        self.object = object
        self.created = created
        self.model = model
        self.systemFingerprint = systemFingerprint
        self.choices = choices
        self.usage = usage
    }
}

public struct Choice: Decodable {
    let index: Int
    public let message: ChatMessage
    let logprobs: LogProbs?
    let finishReason: FinishReason
    
    public enum FinishReason: String, Decodable {
        case stop
        case length
        case contentFilter = "content_filter"
        case toolCalls = "tool_calls"
        case functionCall = "function_call"
    }
    
    private enum CodingKeys: String, CodingKey {
        case index, message, logprobs
        case finishReason = "finish_reason"
    }
    
    public init(index: Int, message: ChatMessage, logprobs: LogProbs? = nil, finishReason: FinishReason) {
        self.index = index
        self.message = message
        self.logprobs = logprobs
        self.finishReason = finishReason
    }
}

public struct Usage: Decodable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int
    
    private enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
    
    public init(promptTokens: Int, completionTokens: Int, totalTokens: Int) {
        self.promptTokens = promptTokens
        self.completionTokens = completionTokens
        self.totalTokens = totalTokens
    }
}

public struct LogProbs: Decodable {
    let content: [Content]?
    let topLogprobs: [TopLogProbs]?
    
    public init(content: [Content]? = nil, topLogprobs: [TopLogProbs]? = nil) {
        self.content = content
        self.topLogprobs = topLogprobs
    }
}

public struct Content: Decodable {
    let token: String
    let logprob: Double
    let bytes: [Int]?
    
    public init(token: String, logprob: Double, bytes: [Int]?) {
        self.token = token
        self.logprob = logprob
        self.bytes = bytes
    }
}

public struct TopLogProbs: Decodable {
    let token: String
    let logprob: Double
    
    public init(token: String, logprob: Double) {
        self.token = token
        self.logprob = logprob
    }
}
