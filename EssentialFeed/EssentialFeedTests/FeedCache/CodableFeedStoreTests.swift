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

class CodableFeedStore: FeedStore {

    // MARK: Lifecycle

    init(storeURL: URL) {
        self.storeURL = storeURL
    }

    // MARK: Internal

    func retrieve(completion: @escaping FeedStore.RetrievalCompletion) {
        guard let data = try? Data(contentsOf: storeURL) else {
            return completion(.empty)
        }

        do {
            let decoder = JSONDecoder()
            let cache = try decoder.decode(Cache.self, from: data)
            completion(.found(feed: cache.localFeed, timestamp: cache.timestamp))
        } catch {
            completion(.failure(error))
        }
    }

    func insert(
        _ feed: [LocalFeedImage],
        timestamp: Date,
        completion: @escaping FeedStore.InsertionCompletion
    ) {
        do {
            let encoder = JSONEncoder()
            let cache = Cache(feed: feed.map(CodableFeedImage.init), timestamp: timestamp)
            let encoded = try! encoder.encode(cache)
            try encoded.write(to: storeURL)
            completion(nil)
        } catch {
            completion(error)
        }
    }

    func deleteCachedFeed(completion: @escaping DeletionCompletion) {
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
        setupEmptyStoreState()
    }

    override func tearDown() {
        super.tearDown()
        undoStoreSideEffects()
    }

    // MARK: Retrieval

    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        expect(sut, toRetrieve: .empty)
    }

    func test_retrieve_hasNoSideEffectsOnEmptyOnEmptyCache() {
        let sut = makeSUT()

        expect(sut, toRetrieveTwice: .empty)
    }

    func test_retrieve_deliversFoundValuesOnNonEmptyCache() {
        let sut = makeSUT()
        let feed = uniqueImageFeed().local
        let timestamp = Date()

        insert((feed, timestamp), to: sut)
        expect(sut, toRetrieve: .found(feed: feed, timestamp: timestamp))
    }

    func test_retrieve_hasNoSideEffectOnNonEmptyCache() {
        let sut = makeSUT()

        let feed = uniqueImageFeed().local
        let timestamp = Date()

        insert((feed, timestamp), to: sut)
        expect(sut, toRetrieveTwice: .found(feed: feed, timestamp: timestamp))
    }

    func test_retrieve_deliversFailureOnRetrievalError() {
        let storeURL = testSpecificstoreURL()
        let sut = makeSUT(storeURL: storeURL)

        try! "invalid_data".write(to: storeURL, atomically: false, encoding: .utf8)

        expect(sut, toRetrieve: .failure(anyNSError()))
    }

    func test_retrieve_hasNoSideEffectsOnFailure() {
        let storeURL = testSpecificstoreURL()
        let sut = makeSUT(storeURL: storeURL)

        try! "invalid_data".write(to: storeURL, atomically: false, encoding: .utf8)

        expect(sut, toRetrieveTwice: .failure(anyNSError()))
    }

    // MARK: Insertion

    func test_insert_overridesPreviouslyIsertedCacheValues() {
        let sut = makeSUT()

        let fisrtInsertionError = insert((uniqueImageFeed().local, Date()), to: sut)
        XCTAssertNil(fisrtInsertionError, "Expected to override cache successfully")

        let latestFeed = uniqueImageFeed().local
        let latestTimestamp = Date()
        let latestInsertionError = insert((latestFeed, latestTimestamp), to: sut)
        XCTAssertNil(latestInsertionError, "Expected to override cache successfully")
        expect(sut, toRetrieve: .found(feed: latestFeed, timestamp: latestTimestamp))
    }

    func test_insert_deliversErrorOnInsertionError() {
        let invalidStoreURL = URL(string: "invalid://store-url")
        let sut = makeSUT(storeURL: invalidStoreURL)
        let feed = uniqueImageFeed().local
        let timestamp = Date()

        let insertionError = insert((feed, timestamp), to: sut)
        XCTAssertNotNil(insertionError, "Expected cache insertion to fail with an error")
    }

    // MARK: Deletion

    func test_delete_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        let exp = expectation(description: "Wait for cache deletion")

        sut.deleteCachedFeed { deletionError in
            XCTAssertNil(deletionError, "Expected empty cache deletion to succeed")
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)

        expect(sut, toRetrieve: .empty)
    }

    // MARK: Private

    // MARK: Helpers

    private func makeSUT(storeURL: URL? = nil, file: StaticString = #file, line: UInt = #line) -> CodableFeedStore {
        let sut = CodableFeedStore(storeURL: storeURL ?? testSpecificstoreURL())
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    @discardableResult
    private func insert(
        _ cache: (
            feed: [LocalFeedImage],
            timestamp: Date
        ),
        to sut: CodableFeedStore,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Error? {
        let exp = expectation(description: "Wait for cache insertion")
        var insertionError: Error?
        sut.insert(cache.feed, timestamp: cache.timestamp) { receivedInsertionError in
            insertionError = receivedInsertionError
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)

        return insertionError
    }

    private func expect(_ sut: CodableFeedStore, toRetrieve expectedResult: RetrieveCacheResult, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for cache retriaval")
        sut.retrieve { retrievedResult in
            switch (expectedResult, retrievedResult) {
            case (.empty, .empty),
                 (.failure, .failure):
                break

            case let (.found(expected), .found(retrieved)):
                XCTAssertEqual(retrieved.feed, expected.feed, file: file, line: line)
                XCTAssertEqual(retrieved.timestamp, expected.timestamp, file: file, line: line)

            default:
                XCTFail("Expected to retrieved \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }

    private func expect(_ sut: CodableFeedStore, toRetrieveTwice expectedResult: RetrieveCacheResult, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }

    private func testSpecificstoreURL() -> URL {
        return FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        ).first!.appendingPathComponent("\(type(of: self)).store")
    }

    private func deleteStoreArtifects() {
        try? FileManager.default.removeItem(at: testSpecificstoreURL())
    }

    private func setupEmptyStoreState() {
        deleteStoreArtifects()
    }

    private func undoStoreSideEffects() {
        deleteStoreArtifects()
    }

}
