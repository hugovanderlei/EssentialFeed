//
//  LocalFeedImageDataLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Hugo Vanderlei on 12/12/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import EssentialFeed
import XCTest

// MARK: - LocalFeedImageDataLoader

final class LocalFeedImageDataLoader {
    init(store: Any) {}
}

// MARK: - LocalFeedImageDataLoaderTests

class LocalFeedImageDataLoaderTests: XCTestCase {

    // MARK: Nested Types

    private class FeedStoreSpy {
        let receivedMessages = [Any]()
    }

    // MARK: Functions

    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertTrue(store.receivedMessages.isEmpty)
    }

    // MARK: - Helpers

    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedImageDataLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedImageDataLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }

}
