//
//  ValidateFeedCacheUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Hugo Vanderlei on 29/09/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import EssentialFeed
import XCTest

// MARK: - ValidateFeedCacheUseCaseTests

final class ValidateFeedCacheUseCaseTests: XCTestCase {

    // MARK: Internal

    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        XCTAssertEqual(store.receivedMessages, [])
    }

    func test_load_validateCache_deletesCacheOnRetrievalError() {
        let (sut, store) = makeSUT()

        sut.validateCache { _ in }

        store.completeRetrieval(with: anyNSError())

        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCahedFeed])
    }

    func test_validateCache_doesNotdeletesCacheOnEmptyCache() {
        let (sut, store) = makeSUT()

        sut.validateCache { _ in }
        store.completeRetrievalWithEmptyCache()

        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }

    func test_validateCache_doesNotdeleteOnNonExpiredCache() {
        let feed = uniqueImageFeed()

        let fixedCurrentDate = Date()
        let nonExpiredTimeStamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: 1)

        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        sut.validateCache { _ in }
        store.completeRetrieval(with: feed.local, timestamp: nonExpiredTimeStamp)
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }

    func test_validateCache_deletesCacheOnExpiration() {
        let feed = uniqueImageFeed()

        let fixedCurrentDate = Date()
        let expirationTimeStamp = fixedCurrentDate.minusFeedCacheMaxAge()

        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        sut.validateCache { _ in }
        store.completeRetrieval(with: feed.local, timestamp: expirationTimeStamp)
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCahedFeed])
    }

    func test_validateCache_deletesExpiredCache() {
        let feed = uniqueImageFeed()

        let fixedCurrentDate = Date()
        let expiredCacheTimeStamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: -1)

        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        sut.validateCache { _ in }
        store.completeRetrieval(with: feed.local, timestamp: expiredCacheTimeStamp)
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCahedFeed])
    }

    func test_validateCache_doesNotDeleteInvalidCacheAfterSUTInstanceHasBeenDeallocated() {
        let store = FeedStoreSpy()
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store, currentDate: Date.init)

        sut?.validateCache { _ in }

        sut = nil
        store.completeRetrieval(with: anyNSError())

        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }

    // MARK: Private

    private func makeSUT(
        currentDate: @escaping () -> Date = Date.init,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }

}
