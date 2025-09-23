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
    var insertCallCount = 0


    func deleteCachedFeed() {
        deleteCahedFeedCallCount += 1
    }
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        
    }

}

// MARK: - CacheFeedUseCaseTests

class CacheFeedUseCaseTests: XCTestCase {

    // MARK: Internal

    func test_init_doesNotDeleteCacheUponCreation() {
        let (_, store) = makeSUT()
        XCTAssertEqual(store.deleteCahedFeedCallCount, 0)
    }

    func test_save_requestCacheDeletions() {
        let items = [uniqueItem(), uniqueItem()]
        let (sut, store) = makeSUT()
        sut.save(items)

        XCTAssertEqual(store.deleteCahedFeedCallCount, 1)
    }
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError() {
        let items = [uniqueItem(), uniqueItem()]
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        sut.save(items)
        
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.insertCallCount, 0)
    }

    // MARK: Private

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStore) {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file:file, line: line)
        return (sut, store)
    }

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
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
    

}
