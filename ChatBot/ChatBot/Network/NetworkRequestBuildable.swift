//
//  NetworkRequestBuilder.swift
//  ChatBot
//
//  Created by Janine on 1/5/24.
//

import Foundation

protocol NetworkRequestBuildable {
    associatedtype RequestBody: Encodable
    
    var baseURL: String { get }
    var path: String { get }
    var httpMethod: HttpMethod { get }
    var headers: [String: Any] { get }
    var authKey: String? { get }
    var contentType: String { get }
    var body: RequestBody { get }
}

extension NetworkRequestBuildable {
    var baseURL: String { "https://api.openai.com/" }
    var headers: [String: Any] { [:] }
    var contentType: String { "application/json" }
}
