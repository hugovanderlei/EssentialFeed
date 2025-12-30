//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Hugo Vanderlei on 30/12/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import Foundation

public protocol FeedCache {
    typealias Result = Swift.Result<Void, Error>

    func save(_ feed: [FeedImage], completion: @escaping (Result) -> Void)
}
