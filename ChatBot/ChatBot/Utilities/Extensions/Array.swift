//
//  Array.swift
//  ChatBot
//
//  Created by Janine on 1/18/24.
//

import Foundation

extension Array {
    public subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        return self[index]
    }
}
