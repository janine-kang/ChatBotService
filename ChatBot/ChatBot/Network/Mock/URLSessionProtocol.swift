//
//  URLSessionProtocol.swift
//  ChatBot
//
//  Created by Janine on 5/15/24.
//

import Foundation

protocol URLSessionProtocol {
    func customData(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {
    func customData(for request: URLRequest) async throws -> (Data, URLResponse) {
        let (data, response) = try await data(for: request)
        return (data, response)
    }
}
