//
//  LocalFeedImageDataLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Hugo Vanderlei on 12/12/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import EssentialFeed
import XCTest

// MARK: - FeedImageDataStore

protocol FeedImageDataStore {
    func retrieve(dataForURL url: URL)
}

// MARK: - LocalFeedImageDataLoader

final class LocalFeedImageDataLoader: FeedImageDataLoader {

    // MARK: Nested Types

    private struct Task: FeedImageDataLoaderTask {
        func cancel() {}
    }

    // MARK: Properties

    private let store: FeedImageDataStore

    // MARK: Lifecycle

    init(store: FeedImageDataStore) {
        self.store = store
    }

    // MARK: Functions

    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        store.retrieve(dataForURL: url)
        return Task()
    }
}

// MARK: - LocalFeedImageDataLoaderTests

class LocalFeedImageDataLoaderTests: XCTestCase {

    // MARK: Nested Types

    private class StoreSpy: FeedImageDataStore {

        // MARK: Nested Types

        enum Message: Equatable {
            case retrieve(dataFor: URL)
        }

        // MARK: Properties

        private(set) var receivedMessages = [Message]()

        // MARK: Functions

        func retrieve(dataForURL url: URL) {
            receivedMessages.append(.retrieve(dataFor: url))
        }
    }

    // MARK: Functions

    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertTrue(store.receivedMessages.isEmpty)
    }

    func test_loadImageDataFromURL_requestsStoredDataForURL() {
        let (sut, store) = makeSUT()
        let url = anyURL()

        _ = sut.loadImageData(from: url) { _ in }

        XCTAssertEqual(store.receivedMessages, [.retrieve(dataFor: url)])
    }

    // MARK: - Helpers

    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedImageDataLoader, store: StoreSpy) {
        let store = StoreSpy()
        let sut = LocalFeedImageDataLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }

}
