//
//  UIRefreshControl+Helpers.swift
//  EssentialFeediOS
//
//  Created by Hugo Vanderlei on 09/12/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
