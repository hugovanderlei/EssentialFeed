//
//  RemoteFeedImageDataLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Hugo Vanderlei on 11/12/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import EssentialFeed
import XCTest

// MARK: - RemoteFeedImageDataLoader

class RemoteFeedImageDataLoader {
    init(client: Any) {}
}

// MARK: - RemoteFeedImageDataLoaderTests

final class RemoteFeedImageDataLoaderTests: XCTestCase {

    // MARK: Nested Types

    private class HTTPClientSpy {
        var requestedURLs = [URL]()
    }

    // MARK: Functions

    func test_init_doesNotPerformAnyURLRequest() {
        let (_, client) = makeSUT()

        XCTAssertTrue(client.requestedURLs.isEmpty)
    }

    private func makeSUT(url: URL = anyURL(), file: StaticString = #file, line: UInt = #line) -> (sut: RemoteFeedImageDataLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedImageDataLoader(client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }

}
