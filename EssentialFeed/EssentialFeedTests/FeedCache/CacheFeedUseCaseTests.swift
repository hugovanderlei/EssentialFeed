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

    init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }

    // MARK: Internal

    let store: FeedStore

    func save(_ items: [FeedItem]?) {
        store.deleteCachedFeed { [unowned self] error in
            if error == nil {
                if let items {
                    self.store.insert(items, timestamp: self.currentDate())
                }
            }
        }
    }

    // MARK: Private

    private let currentDate: () -> Date

}

// MARK: - FeedStore

class FeedStore {

    // MARK: Internal

    typealias DeletionCompletion = (Error?) -> Void

    var deleteCahedFeedCallCount = 0
    var insertions = [(items: [FeedItem], timestamp: Date)]()

    func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        deleteCahedFeedCallCount += 1
        deletionCompletions.append(completion)
    }

    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletions[index](error)
    }

    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](nil)
    }

    func insert(_ items: [FeedItem], timestamp: Date) {
        insertions.append((items, timestamp))
    }

    // MARK: Private

    private var deletionCompletions = [DeletionCompletion]()

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

        XCTAssertEqual(store.insertions.count, 0)
    }

    func test_save_requestsNewCacheInsertionOWithTimeStampOnSuccessDeletion() {
        let timestamp = Date()
        let items = [uniqueItem(), uniqueItem()]
        let (sut, store) = makeSUT(currentDate: { timestamp })
        sut.save(items)
        store.completeDeletionSuccessfully()
        XCTAssertEqual(store.insertions.count, 1)
        XCTAssertEqual(store.insertions.first?.items, items)
        XCTAssertEqual(store.insertions.first?.timestamp, timestamp)
    }

    // MARK: Private

    // MARK: - Helpers

    private func makeSUT(
        currentDate: @escaping () -> Date = Date.init,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: LocalFeedLoader, store: FeedStore) {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
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
