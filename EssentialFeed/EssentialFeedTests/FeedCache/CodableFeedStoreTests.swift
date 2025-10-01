//
//  CodableFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by Hugo Vanderlei on 30/09/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import EssentialFeed
import XCTest

// MARK: - CodableFeedStore

class CodableFeedStore {

    // MARK: Lifecycle

    init(storeURL: URL) {
        self.storeURL = storeURL
    }

    // MARK: Internal

    func retrieve(completion: @escaping FeedStore.RetrievalCompletion) {
        guard let data = try? Data(contentsOf: storeURL) else {
            return completion(.empty)
        }

        let decoder = JSONDecoder()
        let cache = try! decoder.decode(Cache.self, from: data)
        completion(.found(feed: cache.localFeed, timestamp: cache.timestamp))
    }

    func insert(
        _ feed: [LocalFeedImage],
        timestamp: Date,
        completion: @escaping FeedStore.InsertionCompletion
    ) {
        let encoder = JSONEncoder()
        let cache = Cache(feed: feed.map(CodableFeedImage.init), timestamp: timestamp)
        let encoded = try! encoder.encode(cache)
        try! encoded.write(to: storeURL)
        completion(nil)
    }

    // MARK: Private

    private struct Cache: Codable {
        let feed: [CodableFeedImage]
        let timestamp: Date

        var localFeed: [LocalFeedImage] {
            return feed.map { $0.local }
        }
    }

    private struct CodableFeedImage: Codable {

        // MARK: Lifecycle

        init(_ image: LocalFeedImage) {
            id = image.id
            description = image.description
            location = image.location
            url = image.url
        }

        // MARK: Internal

        var local: LocalFeedImage {
            return LocalFeedImage(
                id: id,
                description: description,
                location: location,
                url: url
            )
        }

        // MARK: Private

        private let id: UUID
        private let description: String?
        private let location: String?
        private let url: URL

    }

    private let storeURL: URL

}

// MARK: - CodableFeedStoreTests

final class CodableFeedStoreTests: XCTestCase {

    // MARK: Internal

    override func setUp() {
        super.setUp()

        try? FileManager.default.removeItem(at: storeURL())
    }

    override func tearDown() {
        super.tearDown()

        try? FileManager.default.removeItem(at: storeURL())
    }

    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()

        let exp = expectation(description: "Wait for cache retriaval")

        sut.retrieve { result in
            switch result {
            case .empty:
                break

            default:
                XCTFail("Expected empty result, got \(result)")
            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }

    func test_retrieve_hasNoSideEffectsOnEmptyOnEmptyCache() {
        let sut = makeSUT()

        let exp = expectation(description: "Wait for cache retriaval")
        sut.retrieve { firstResult in
            sut.retrieve { secondResult in
                switch (firstResult, secondResult) {
                case (.empty, .empty):
                    break

                default:
                    XCTFail("Expected retrieving twice from empty cache to deliver same empty result, got \(firstResult) and \(secondResult)")
                }

                exp.fulfill()
            }
        }

        wait(for: [exp], timeout: 1.0)
    }

    func test_retrieveAfterInsertingToEmptyCache_deliversInsertedValues() {
        let sut = makeSUT()

        let feed = uniqueImageFeed().local
        let timestamp = Date()

        let exp = expectation(description: "Wait for cache retriaval")
        sut.insert(feed, timestamp: timestamp) { insertionError in
            XCTAssertNil(insertionError, "Expected feed to be inserted successfully")

            sut.retrieve { retrieveResult in
                switch retrieveResult {
                case let .found(retrievedFeed, timestamp: retrievedTimestamp):
                    XCTAssertEqual(retrievedFeed, feed)
                    XCTAssertEqual(timestamp, retrievedTimestamp)

                default:
                    XCTFail("Expected found result with feed \(feed) and timestamp \(timestamp), got \(retrieveResult)")
                }

                exp.fulfill()
            }
        }

        wait(for: [exp], timeout: 1.0)
    }

    // MARK: Private

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> CodableFeedStore {
        let storeURL = storeURL()

        let sut = CodableFeedStore(storeURL: storeURL)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    private func storeURL() -> URL {
        return FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first!.appendingPathComponent("image-feed-store")
    }
}
