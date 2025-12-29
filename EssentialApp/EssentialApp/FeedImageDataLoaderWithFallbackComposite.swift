//
//  FeedImageDataLoaderWithFallbackComposite.swift
//  EssentialApp
//
//  Created by Hugo Vanderlei on 29/12/25.
//

import EssentialFeed
import Foundation

public class FeedImageDataLoaderWithFallbackComposite: FeedImageDataLoader {

    // MARK: Nested Types

    private class TaskWrapper: FeedImageDataLoaderTask {

        // MARK: Properties

        var wrapped: FeedImageDataLoaderTask?

        // MARK: Functions

        func cancel() {
            wrapped?.cancel()
        }
    }

    // MARK: Properties

    private let primary: FeedImageDataLoader
    private let fallback: FeedImageDataLoader

    // MARK: Lifecycle

    public init(primary: FeedImageDataLoader, fallback: FeedImageDataLoader) {
        self.primary = primary
        self.fallback = fallback
    }

    // MARK: Functions

    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        let task = TaskWrapper()
        task.wrapped = primary.loadImageData(from: url) { [weak self] result in
            switch result {
            case .success:
                completion(result)

            case .failure:
                task.wrapped = self?.fallback.loadImageData(from: url, completion: completion)
            }
        }
        return task
    }
}
