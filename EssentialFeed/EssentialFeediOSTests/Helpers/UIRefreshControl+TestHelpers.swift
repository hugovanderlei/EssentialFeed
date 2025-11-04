//
//  UIRefreshControl+TestHelpers.swift
//  EssentialFeed
//
//  Created by Hugo Vanderlei on 04/11/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//
import UIKit

extension UIRefreshControl {
    func simulatePullToRefresh() {
        for target in allTargets {
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
