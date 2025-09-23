//
//  CacheFeedUseCaseTests.swift
//  EssentialFeed
//
//  Created by Hugo Vanderlei on 08/09/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//
@testable import EssentialFeed
import XCTest

// MARK: - LocalFeedLoader

class LocalFeedLoader {

    // MARK: Lifecycle

    init(store: FeedStore) {
        self.store = store
    }

    // MARK: Internal

    let store: FeedStore

    func save(_ items: [FeedItem]?) {
        store.deleteCachedFeed()
    }
}

// MARK: - FeedStore

class FeedStore {
    var deleteCahedFeedCallCount = 0

    func deleteCachedFeed() {
        deleteCahedFeedCallCount += 1
    }

}

// MARK: - CacheFeedUseCaseTests

class CacheFeedUseCaseTests: XCTestCase {

    // MARK: Internal

    func test_init_doesNotDeleteCacheUponCreation() {
        let store = FeedStore()
        _ = LocalFeedLoader(store: store)
        XCTAssertEqual(store.deleteCahedFeedCallCount, 0)
    }

    func test_save_requestCacheDeletions() {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store)

        let items = [uniqueItem(), uniqueItem()]
        sut.save(items)

        XCTAssertEqual(store.deleteCahedFeedCallCount, 1)
    }

    // MARK: Private

    // MARK: - Helpers

    private func uniqueItem() -> FeedItem {
        return FeedItem(
            id: UUID(),
            description: "any",
            location: "any",
            imageURL: anyURL()
        )
    }

    private func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }

}
