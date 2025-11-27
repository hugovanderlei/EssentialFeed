//
//  UIControl+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Hugo Vanderlei on 04/11/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import UIKit

extension UIControl {
    func simulate(event: UIControl.Event) {
        for target in allTargets {
            actions(forTarget: target, forControlEvent: event)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
