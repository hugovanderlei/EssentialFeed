//
//  LoadFeedFromCacheUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Hugo Vanderlei on 25/09/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import EssentialFeed
import XCTest

// MARK: - LoadFeedFromCacheUseCaseTests

final class LoadFeedFromCacheUseCaseTests: XCTestCase {

    // MARK: Internal

    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        XCTAssertEqual(store.receivedMessages, [])
    }

    func test_load_requestCacheRetrieval() {
        let (sut, store) = makeSUT()
        sut.load { _ in }
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }

    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let retrievalError = anyNSError()

        expect(sut, toCompleteWith: .failure(retrievalError)) {
            store.completeRetrieval(with: retrievalError)
        }
    }

    func test_load_deliversNoImagesOnEmptyCache() {
        let (sut, store) = makeSUT()

        expect(sut, toCompleteWith: .success([])) {
            store.completeRetrievalWithEmptyCache()
        }
    }

    func test_load_deliversCachedImagesOnLessThenSevenDaysOldCache() {
        let feed = uniqueImageFeed()

        let fixedCurrentDate = Date()
        let lessThanSevenDaysOldTimeStamp = fixedCurrentDate.adding(days: -7)
            .adding(
                seconds: 1
            )

        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        expect(sut, toCompleteWith: .success(feed.models)) {
            store.completeRetrieval(
                with: feed.local,
                timestamp: lessThanSevenDaysOldTimeStamp
            )
        }
    }

    func test_load_deliversNoImagesOnMoreThanSevenDaysOldCache() {
        let feed = uniqueImageFeed()

        let fixedCurrentDate = Date()
        let moreThanSevenDaysOldTimeStamp = fixedCurrentDate.adding(days: -7)
            .adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        expect(sut, toCompleteWith: .success([])) {
            store.completeRetrieval(
                with: feed.local,
                timestamp: moreThanSevenDaysOldTimeStamp
            )
        }
    }

    func test_load_hasNoSideEffectsOnRetrievalError() {
        let (sut, store) = makeSUT()

        sut.load { _ in }

        store.completeRetrieval(with: anyNSError())

        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }

    func test_load_hasNoSideEffectsOnEmptyCache() {
        let (sut, store) = makeSUT()

        sut.load { _ in }

        store.completeRetrievalWithEmptyCache()

        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }

    func test_load_hasNoSideEffectsOnLessThanSevenDaysOldCache() {
        let feed = uniqueImageFeed()

        let fixedCurrentDate = Date()
        let lessThanSevenDaysOldTimeStamp = fixedCurrentDate.adding(days: -7)
            .adding(
                seconds: 1
            )

        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        sut.load { _ in }
        store.completeRetrieval(with: feed.local, timestamp: lessThanSevenDaysOldTimeStamp)
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }

    func test_load_hasNoSideEffectsOnSevenDaysOldCache() {
        let feed = uniqueImageFeed()

        let fixedCurrentDate = Date()
        let sevenDaysOldTimeStamp = fixedCurrentDate.adding(days: -7)

        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        sut.load { _ in }
        store.completeRetrieval(with: feed.local, timestamp: sevenDaysOldTimeStamp)
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }

    func test_load_hasNoSideEffectsOnMoreThanSevenDaysOldCache() {
        let feed = uniqueImageFeed()

        let fixedCurrentDate = Date()
        let moreThanSevenDaysOldTimeStamp = fixedCurrentDate.adding(days: -7).adding(days: -1)

        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        sut.load { _ in }
        store.completeRetrieval(with: feed.local, timestamp: moreThanSevenDaysOldTimeStamp)
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }

    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let store = FeedStoreSpy()
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store, currentDate: Date.init)

        var receivedResult = [LocalFeedLoader.LoadResult]()
        sut?.load { receivedResult.append($0) }

        sut = nil
        store.completeRetrievalWithEmptyCache()

        XCTAssertTrue(receivedResult.isEmpty)
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

    private func expect(
        _ sut: LocalFeedLoader,
        toCompleteWith expectedResult: LocalFeedLoader.LoadResult,
        when action: () -> Void,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for load completion")
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedImages), .success(expectedImages)):
                XCTAssertEqual(receivedImages, expectedImages)

            case let (
                .failure(receivedError as NSError),
                .failure(expectedError as NSError)
            ):
                XCTAssertEqual(receivedError, expectedError)

            default:
                XCTFail("Expected result, got \(receivedResult) instead")
            }

            exp.fulfill()
        }

        action()

        wait(for: [exp], timeout: 1.0)
    }

}
