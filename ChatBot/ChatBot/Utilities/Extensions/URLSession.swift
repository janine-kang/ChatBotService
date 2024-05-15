//
//  URLSession.swift
//  ChatBot
//
//  Created by Janine on 1/24/24.
//

import Foundation
import Combine

extension URLSession {
    
    func dataTaskPublisher(with request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        
        return Deferred {
            Future<(data: Data, response: URLResponse), URLError> { promise in
                let task = self.dataTask(with: request) { data, response, error in
                    if let error = error as? URLError {
                        promise(.failure(error))
                    } else if let data = data, let response = response {
                        promise(.success((data: data, response: response)))
                    } else {
                        let error = URLError(.unknown)
                        promise(.failure(error))
                    }
                }
                task.resume()
            }
        }
        .eraseToAnyPublisher()
    }
}
