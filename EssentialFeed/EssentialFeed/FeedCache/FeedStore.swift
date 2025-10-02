//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Hugo Vanderlei on 24/09/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//
import Foundation

// MARK: - RetrieveCacheResult

public enum RetrieveCacheResult {
    case empty
    case found(feed: [LocalFeedImage], timestamp: Date)
    case failure(Error)

}

// MARK: - FeedStore

public protocol FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    typealias RetrievalCompletion = (RetrieveCacheResult) -> Void

    /// The completion handler can be invoked in any thread
    /// Clients are responsible to dispatch to appropiate thread, if needed
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion)

    /// The completion handler can be invoked in any thread
    /// Clients are responsible to dispatch to appropiate thread, if needed
    func deleteCachedFeed(completion: @escaping DeletionCompletion)

    /// The completion handler can be invoked in any thread
    /// Clients are responsible to dispatch to appropiate thread, if needed
    func retrieve(completion: @escaping RetrievalCompletion)
}
