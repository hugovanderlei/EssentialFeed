//
//  CacheFeedUseCaseTests.swift
//  EssentialFeed
//
//  Created by Hugo Vanderlei on 08/09/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//
import XCTest



class LocalFeedLoader {
    init(store:FeedStore) {
        
    }
}

class FeedStore {
    var deleteCahedFeedCallCount = 0
}

class CacheFeedUseCaseTests: XCTestCase {
    
    func test_init_doesNotDeleteCacheUponCreation() {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store)
        XCTAssertEqual(store.deleteCahedFeedCallCount, 0)
    }

}
