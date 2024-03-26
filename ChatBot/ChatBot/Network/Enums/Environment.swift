//
//  Environment.swift
//  ChatBot
//
//  Created by 동준 on 1/5/24.
//

import Foundation

enum Environment {
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist file not found")
        }
        return dict
    }()

    static let apiKey: String = {
        guard let string = infoDictionary["CHAT_API_KEY"] as? String else { fatalError("not exists in plist") }
        return string
    }()
}

