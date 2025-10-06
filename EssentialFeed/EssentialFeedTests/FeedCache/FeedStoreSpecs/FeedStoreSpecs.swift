//
//  FeedStoreSpecs.swift
//  EssentialFeedTests
//
//  Created by Hugo Vanderlei on 03/10/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import Foundation

// MARK: - FeedStoreSpecs

protocol FeedStoreSpecs {
    func test_retrieve_deliversEmptyOnEmptyCache() throws
    func test_retrieve_hasNoSideEffectsOnEmptyCache() throws
    func test_retrieve_deliversFoundValuesOnNonEmptyCache() throws
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() throws

    func test_insert_deliversNoErrorOnEmptyCache() throws
    func test_insert_deliversNoErrorOnNonEmptyCache() throws
    func test_insert_overridesPreviouslyInsertedCacheValues() throws

    func test_delete_deliversNoErrorOnEmptyCache() throws
    func test_delete_hasNoSideEffectsOnEmptyCache() throws
    func test_delete_deliversNoErrorOnNonEmptyCache() throws
    func test_delete_emptiesPreviouslyInsertedCache() throws
}

// MARK: - FailableRetrieveFeedStoreSpecs

protocol FailableRetrieveFeedStoreSpecs: FeedStoreSpecs {
    func test_retrieve_deliversFailureOnRetrievalError() throws
    func test_retrieve_hasNoSideEffectsOnFailure() throws
}

// MARK: - FailableInsertFeedStoreSpecs

protocol FailableInsertFeedStoreSpecs: FeedStoreSpecs {
    func test_insert_deliversErrorOnInsertionError() throws
    func test_insert_hasNoSideEffectsOnInsertionError() throws
}

// MARK: - FailableDeleteFeedStoreSpecs

protocol FailableDeleteFeedStoreSpecs: FeedStoreSpecs {
    func test_delete_deliversErrorOnDeletionError() throws
    func test_delete_hasNoSideEffectsOnDeletionError() throws
}

typealias FailableFeedStoreSpecs = FailableDeleteFeedStoreSpecs & FailableInsertFeedStoreSpecs & FailableRetrieveFeedStoreSpecs
