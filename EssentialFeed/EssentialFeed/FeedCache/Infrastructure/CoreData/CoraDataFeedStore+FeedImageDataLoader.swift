//
//  CoraDataFeedStore+FeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Hugo Vanderlei on 16/12/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import Foundation

extension CoreDataFeedStore: FeedImageDataStore {

    public func insert(_ data: Data, for url: URL, completion: @escaping (FeedImageDataStore.InsertionResult) -> Void) {}

    public func retrieve(dataForURL url: URL, completion: @escaping (FeedImageDataStore.RetrievalResult) -> Void) {
        completion(.success(.none))
    }

}
