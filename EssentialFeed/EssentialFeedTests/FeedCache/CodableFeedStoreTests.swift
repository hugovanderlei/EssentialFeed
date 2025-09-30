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
    func retrieve(completion: @escaping FeedStore.RetrievalCompletion) {
        completion(.empty)
    }
}

// MARK: - CodableFeedStoreTests

final class CodableFeedStoreTests: XCTestCase {

    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = CodableFeedStore()

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
}
