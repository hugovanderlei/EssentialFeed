//
//  CoreDataFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by Hugo Vanderlei on 03/10/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import XCTest

final class CoreDataFeedStoreTests: XCTestCase, FeedStoreSpecs {
    func test_retrieve_deliversEmptyOnEmptyCache() {}

    func test_retrieve_hasNoSideEffectsOnEmptyCache() {}

    func test_retrieve_deliversFoundValuesOnNonEmptyCache() {}

    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {}

    func test_insert_deliversNoErrorOnEmptyCache() {}

    func test_insert_deliversNoErrorOnNonEmptyCache() {}

    func test_insert_overridesPreviouslyInsertedCacheValues() {}

    func test_delete_deliversNoErrorOnEmptyCache() {}

    func test_delete_hasNoSideEffectsOnEmptyCache() {}

    func test_delete_deliversNoErrorOnNonEmptyCache() {}

    func test_delete_emptiesPreviouslyInsertedCache() {}

    func test_storeSideEffects_runSerially() {}

}
