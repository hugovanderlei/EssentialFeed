//
//  FeedImageDataLoaderWithFallbackCompositeTests.swift
//  EssentialAppTests
//
//  Created by Hugo Vanderlei on 26/12/25.
//

import EssentialFeed
import XCTest

// MARK: - FeedImageDataLoaderWithFallbackComposite

class FeedImageDataLoaderWithFallbackComposite: FeedImageDataLoader {

    // MARK: Nested Types

    private class Task: FeedImageDataLoaderTask {
        func cancel() {}
    }

    // MARK: Lifecycle

    init(primary: FeedImageDataLoader, fallback: FeedImageDataLoader) {}

    // MARK: Functions

    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        return Task()
    }
}

// MARK: - FeedImageDataLoaderWithFallbackCompositeTests

class FeedImageDataLoaderWithFallbackCompositeTests: XCTestCase {

    // MARK: Nested Types

    // MARK: - Helpers

    private class LoaderSpy: FeedImageDataLoader {

        // MARK: Nested Types

        private struct Task: FeedImageDataLoaderTask {
            func cancel() {}
        }

        // MARK: Properties

        private var messages = [(url: URL, completion: (FeedImageDataLoader.Result) -> Void)]()

        // MARK: Computed Properties

        var loadedURLs: [URL] {
            return messages.map { $0.url }
        }

        // MARK: Functions

        func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
            messages.append((url, completion))
            return Task()
        }
    }

    // MARK: Functions

    func test_init_doesNotLoadImageData() {
        let primaryLoader = LoaderSpy()
        let fallbackLoader = LoaderSpy()
        _ = FeedImageDataLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)

        XCTAssertTrue(primaryLoader.loadedURLs.isEmpty, "Expected no loaded URLs in the primary loader")
        XCTAssertTrue(fallbackLoader.loadedURLs.isEmpty, "Expected no loaded URLs in the fallback loader")
    }

}
