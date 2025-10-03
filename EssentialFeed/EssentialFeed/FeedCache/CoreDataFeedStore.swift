//
//  CoreDataFeedStore.swift
//  EssentialFeedTests
//
//  Created by Hugo Vanderlei on 03/10/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import Foundation

public final class CoreDataFeedStore: FeedStore {

    // MARK: Lifecycle

    public init() {}

    // MARK: Functions

    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {}

    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {}

    public func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.empty)
    }

}
