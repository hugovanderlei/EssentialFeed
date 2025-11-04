//
//  UIButton+TestHelpers.swift
//  EssentialFeed
//
//  Created by Hugo Vanderlei on 04/11/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//
import UIKit

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}
