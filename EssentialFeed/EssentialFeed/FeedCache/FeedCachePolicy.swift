//
//  FeedCachePolicy.swift
//  EssentialFeed
//
//  Created by Hugo Vanderlei on 30/09/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import Foundation

final class FeedCachePolicy {

    // MARK: Lifecycle

    private init() {}

    // MARK: Internal

    static func validate(_ timestamp: Date, against date: Date) -> Bool {
        guard
            let maxCacheAge = calendar.date(
                byAdding: .day,
                value: maxCacheAgeInDays,
                to: timestamp
            )
        else {
            return false
        }
        return date < maxCacheAge
    }

    // MARK: Private

    private static let calendar = Calendar(identifier: .gregorian)

    private static var maxCacheAgeInDays: Int {
        return 7
    }

}
