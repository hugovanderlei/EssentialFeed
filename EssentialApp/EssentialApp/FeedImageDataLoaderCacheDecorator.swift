//
//  FeedImageDataLoaderCacheDecorator.swift
//  EssentialApp
//
//  Created by Hugo Vanderlei on 30/12/25.
//

import EssentialFeed
import Foundation

public final class FeedImageDataLoaderCacheDecorator: FeedImageDataLoader {

    // MARK: Properties

    private let decoratee: FeedImageDataLoader
    private let cache: FeedImageDataCache

    // MARK: Lifecycle

    public init(decoratee: FeedImageDataLoader, cache: FeedImageDataCache) {
        self.decoratee = decoratee
        self.cache = cache
    }

    // MARK: Functions

    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        return decoratee.loadImageData(from: url) { [weak self] result in
            completion(result.map { data in
                self?.cache.save(data, for: url) { _ in }
                return data
            })
        }
    }
}
