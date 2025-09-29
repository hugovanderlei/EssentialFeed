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

        sut.validateCache()

        store.completeRetrieval(with: anyNSError())

        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCahedFeed])
    }

    func test_validateCache_doesNotdeletesCacheOnEmptyCache() {
        let (sut, store) = makeSUT()

        sut.validateCache()
        store.completeRetrievalWithEmptyCache()

        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }

    func test_validateCache_doesNotdeleteLessThanSevenDaysOldCache() {
        let feed = uniqueImageFeed()

        let fixedCurrentDate = Date()
        let lessThanSevenDaysOldTimeStamp = fixedCurrentDate.adding(days: -7)
            .adding(
                seconds: 1
            )

        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        sut.validateCache()
        store.completeRetrieval(with: feed.local, timestamp: lessThanSevenDaysOldTimeStamp)
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }

    func test_validateCache_deleresOnSevenDaysOldCache() {
        let feed = uniqueImageFeed()

        let fixedCurrentDate = Date()
        let sevenDaysOldTimeStamp = fixedCurrentDate.adding(days: -7)

        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        sut.validateCache()
        store.completeRetrieval(with: feed.local, timestamp: sevenDaysOldTimeStamp)
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCahedFeed])
    }

    func test_validateCache_deletesOnMoreThanSevenDaysOldCache() {
        let feed = uniqueImageFeed()

        let fixedCurrentDate = Date()
        let moreThanSevenDaysOldTimeStamp = fixedCurrentDate.adding(days: -7).adding(days: -1)

        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        sut.validateCache()
        store.completeRetrieval(with: feed.local, timestamp: moreThanSevenDaysOldTimeStamp)
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCahedFeed])
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
