//
//  UITableView+Dequeueing.swift
//  EssentialFeediOS
//
//  Created by Hugo Vanderlei on 21/11/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//


import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
