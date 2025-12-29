//
//  FeedLoaderCacheDecoratorTests.swift
//  EssentialAppTests
//
//  Created by Hugo Vanderlei on 29/12/25.
//

import EssentialFeed
import XCTest

// MARK: - FeedLoaderCacheDecorator

final class FeedLoaderCacheDecorator: FeedLoader {

    // MARK: Properties

    private let decoratee: FeedLoader

    // MARK: Lifecycle

    init(decoratee: FeedLoader) {
        self.decoratee = decoratee
    }

    // MARK: Functions

    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        decoratee.load(completion: completion)
    }
}

// MARK: - FeedLoaderCacheDecoratorTests

final class FeedLoaderCacheDecoratorTests: XCTestCase, FeedLoaderTestCase {

    func test_load_deliversFeedOnLoaderSuccess() {
        let feed = uniqueFeed()
        let loader = FeedLoaderStub(result: .success(feed))
        let sut = FeedLoaderCacheDecorator(decoratee: loader)

        expect(sut, toCompleteWith: .success(feed))
    }

    func test_load_deliversErrorOnLoaderFailure() {
        let loader = FeedLoaderStub(result: .failure(anyNSError()))
        let sut = FeedLoaderCacheDecorator(decoratee: loader)

        expect(sut, toCompleteWith: .failure(anyNSError()))
    }

}
