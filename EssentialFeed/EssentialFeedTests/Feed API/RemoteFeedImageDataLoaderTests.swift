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

    // MARK: Properties

    private let client: HTTPClient

    // MARK: Lifecycle

    init(client: HTTPClient) {
        self.client = client
    }

    // MARK: Functions

    func loadImageData(from url: URL, completion: @escaping (Any) -> Void) {
        client.get(from: url) { _ in }
    }
}

// MARK: - RemoteFeedImageDataLoaderTests

class RemoteFeedImageDataLoaderTests: XCTestCase {

    // MARK: Nested Types

    private class HTTPClientSpy: HTTPClient {

        // MARK: Properties

        var requestedURLs = [URL]()

        // MARK: Functions

        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
            requestedURLs.append(url)
        }
    }

    // MARK: Functions

    func test_init_doesNotPerformAnyURLRequest() {
        let (_, client) = makeSUT()

        XCTAssertTrue(client.requestedURLs.isEmpty)
    }

    func test_loadImageDataFromURL_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.loadImageData(from: url) { _ in }

        XCTAssertEqual(client.requestedURLs, [url])
    }

    private func makeSUT(url: URL = anyURL(), file: StaticString = #file, line: UInt = #line) -> (sut: RemoteFeedImageDataLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedImageDataLoader(client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }

}
