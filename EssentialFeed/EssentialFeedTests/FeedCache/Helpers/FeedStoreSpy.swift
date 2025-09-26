//
//  FeedStoreSpy.swift
//  EssentialFeed
//
//  Created by Hugo Vanderlei on 25/09/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import EssentialFeed
import Foundation

public class FeedStoreSpy: FeedStore {

    // MARK: Public

    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        deletionCompletions.append(completion)
        receivedMessages.append(.deleteCahedFeed)
    }

    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        insertionCompletions.append(completion)
        receivedMessages.append(.insert(feed, timestamp))
    }

    public func retrieve(completion: @escaping RetrievalCompletion) {
        retrievalCompletions.append(completion)
        receivedMessages.append(.retrieve)
    }

    public func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletions[index](error)
    }

    public func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](nil)
    }

    public func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletions[index](error)
    }

    public func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletions[index](nil)
    }

    public func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](error)
    }
    
    public func completeRetrievalWithEmptyCache(at index: Int = 0) {
        retrievalCompletions[index](nil)
    }

    // MARK: Internal

    enum ReceivedMessage: Equatable {
        case deleteCahedFeed
        case insert([LocalFeedImage], Date)
        case retrieve
    }

    private(set) var receivedMessages = [ReceivedMessage]()

    // MARK: Private

    private var deletionCompletions = [DeletionCompletion]()
    private var insertionCompletions = [InsertionCompletion]()
    private var retrievalCompletions = [RetrievalCompletion]()

}
