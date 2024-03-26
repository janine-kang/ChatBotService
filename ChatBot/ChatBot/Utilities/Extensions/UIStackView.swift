//
//  UIStackView.swift
//  ChatBot
//
//  Created by Janine on 1/19/24.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach {
            self.addArrangedSubview($0)
        }
    }
}
