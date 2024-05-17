//
//  MockURLSession.swift
//  ChatBot
//
//  Created by Janine on 5/15/24.
//

import Foundation

class MockURLSession: URLSessionProtocol {
    var mockData: Data?
    var mockResponse: HTTPURLResponse?
    var mockError: Error?
    
    init(mockData: Data? = nil, mockResponse: HTTPURLResponse? = nil, mockError: Error? = nil) {
        self.mockData = mockData
        self.mockResponse = createMockResponse()
        self.mockError = mockError
    }

    func customData(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = mockError {
            throw error
        }
        return (mockData ?? Data(), mockResponse ?? HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
    }
}
