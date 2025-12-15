//
//  FeedImageDataStoreSpy.swift
//  EssentialFeed
//
//  Created by Hugo Vanderlei on 15/12/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import EssentialFeed
import Foundation

class FeedImageDataStoreSpy: FeedImageDataStore {

    // MARK: Nested Types

    enum Message: Equatable {
        case insert(data: Data, for: URL)
        case retrieve(dataFor: URL)
    }

    // MARK: Properties

    private(set) var receivedMessages = [Message]()

    private var retrievalCompletions = [(FeedImageDataStore.RetrievalResult) -> Void]()

    // MARK: Functions

    func insert(_ data: Data, for url: URL, completion: @escaping (FeedImageDataStore.InsertionResult) -> Void) {
        receivedMessages.append(.insert(data: data, for: url))
    }

    func retrieve(dataForURL url: URL, completion: @escaping (FeedImageDataStore.RetrievalResult) -> Void) {
        receivedMessages.append(.retrieve(dataFor: url))
        retrievalCompletions.append(completion)
    }

    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](.failure(error))
    }

    func completeRetrieval(with data: Data?, at index: Int = 0) {
        retrievalCompletions[index](.success(data))
    }
}
