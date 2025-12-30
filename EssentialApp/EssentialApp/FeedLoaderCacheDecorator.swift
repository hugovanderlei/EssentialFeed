//
//  FeedLoaderCacheDecorator.swift
//  EssentialApp
//
//  Created by Hugo Vanderlei on 30/12/25.
//

import EssentialFeed

public final class FeedLoaderCacheDecorator: FeedLoader {

    // MARK: Properties

    private let decoratee: FeedLoader
    private let cache: FeedCache

    // MARK: Lifecycle

    public init(decoratee: FeedLoader, cache: FeedCache) {
        self.decoratee = decoratee
        self.cache = cache
    }

    // MARK: Functions

    public func load(completion: @escaping (FeedLoader.Result) -> Void) {
        decoratee.load { [weak self] result in
            completion(result.map { feed in
                self?.cache.save(feed) { _ in }
                return feed
            })
        }
    }
}
