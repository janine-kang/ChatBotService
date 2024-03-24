//
//  ChatType.swift
//  ChatBot
//
//  Created by 동준 on 1/16/24.
//

import Foundation

public enum ChatType: String, Codable {
    case system
    case user
    case tool
    case assistant
}
