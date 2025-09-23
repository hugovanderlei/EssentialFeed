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

    func save(_ items: [FeedItem]?, completion: @escaping (Error?) -> Void) {
        store.deleteCachedFeed { [unowned self] error in
            if error == nil {
                if let items {
                    self.store.insert(
                        items,
                        timestamp: self.currentDate(),
                        completion: completion
                    )
                }
            } else {
                completion(error)
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
    typealias InsertionCompletion = (Error?) -> Void

    enum ReceivedMessage: Equatable {
        case deleteCahedFeed
        case insert([FeedItem], Date)
    }

    private(set) var receivedMessages = [ReceivedMessage]()

    func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        deletionCompletions.append(completion)
        receivedMessages.append(.deleteCahedFeed)
    }

    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletions[index](error)
    }

    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](nil)
    }

    func insert(_ items: [FeedItem], timestamp: Date, completion: @escaping InsertionCompletion) {
        insertionCompletions.append(completion)
        receivedMessages.append(.insert(items, timestamp))
    }

    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletions[index](error)
    }

    // MARK: Private

    private var deletionCompletions = [DeletionCompletion]()
    private var insertionCompletions = [InsertionCompletion]()

}

// MARK: - CacheFeedUseCaseTests

class CacheFeedUseCaseTests: XCTestCase {

    // MARK: Internal

    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        XCTAssertEqual(store.receivedMessages, [])
    }

    func test_save_requestCacheDeletions() {
        let items = [uniqueItem(), uniqueItem()]
        let (sut, store) = makeSUT()
        sut.save(items) { _ in }

        XCTAssertEqual(store.receivedMessages, [.deleteCahedFeed])
    }

    func test_save_doesNotRequestCacheInsertionOnDeletionError() {
        let items = [uniqueItem(), uniqueItem()]
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        sut.save(items) { _ in }

        store.completeDeletion(with: deletionError)

        XCTAssertEqual(store.receivedMessages, [.deleteCahedFeed])
    }

    func test_save_requestsNewCacheInsertionOWithTimeStampOnSuccessDeletion() {
        let timestamp = Date()
        let items = [uniqueItem(), uniqueItem()]
        let (sut, store) = makeSUT(currentDate: { timestamp })
        sut.save(items) { _ in }
        store.completeDeletionSuccessfully()
        XCTAssertEqual(store.receivedMessages, [.deleteCahedFeed, .insert(items, timestamp)])
    }

    func test_save_failsOnDeleteError() {
        let items = [uniqueItem(), uniqueItem()]
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()

        let exp = expectation(description: "Wait for save completion")
        var receivedError: Error?
        sut.save(items) { error in
            receivedError = error
            exp.fulfill()
        }

        store.completeDeletion(with: deletionError)

        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(receivedError as? NSError, deletionError)
    }

    func test_save_failsOnInsertionError() {
        let items = [uniqueItem(), uniqueItem()]
        let (sut, store) = makeSUT()
        let insertionError = anyNSError()

        let exp = expectation(description: "Wait for save completion")
        var receivedError: Error?
        sut.save(items) { error in
            receivedError = error
            exp.fulfill()
        }

        store.completeDeletionSuccessfully()
        store.completeInsertion(with: insertionError)

        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(receivedError as? NSError, insertionError)
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
