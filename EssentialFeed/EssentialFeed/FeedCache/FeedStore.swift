//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Hugo Vanderlei on 24/09/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//
import Foundation

public typealias CachedFeed = (feed: [LocalFeedImage], timestamp: Date)

// MARK: - FeedStore

public protocol FeedStore {

    typealias DeletionResult = Error?
    typealias DeletionCompletion = (DeletionResult) -> Void
    
    typealias InsertionResult = Error?
    typealias InsertionCompletion = (InsertionResult) -> Void
    
    typealias RetrievalResult = Result<CachedFeed?, Error>
    typealias RetrievalCompletion = (RetrievalResult) -> Void

    /// The completion handler can be invoked in any thread
    /// Clients are responsible to dispatch to appropiate thread, if needed
    func deleteCachedFeed(completion: @escaping DeletionCompletion)

    /// The completion handler can be invoked in any thread
    /// Clients are responsible to dispatch to appropiate thread, if needed
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion)

    /// The completion handler can be invoked in any thread
    /// Clients are responsible to dispatch to appropiate thread, if needed
    func retrieve(completion: @escaping RetrievalCompletion)
}
