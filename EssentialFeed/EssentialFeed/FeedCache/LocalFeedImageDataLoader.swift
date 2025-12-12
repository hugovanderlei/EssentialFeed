//
//  LocalFeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Hugo Vanderlei on 12/12/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import Foundation

public final class LocalFeedImageDataLoader: FeedImageDataLoader {

    // MARK: Nested Types

    public enum Error: Swift.Error {
        case failed
        case notFound
    }

    public typealias SaveResult = Result<Void, Swift.Error>

    private final class Task: FeedImageDataLoaderTask {

        // MARK: Properties

        private var completion: ((FeedImageDataLoader.Result) -> Void)?

        // MARK: Lifecycle

        init(_ completion: @escaping (FeedImageDataLoader.Result) -> Void) {
            self.completion = completion
        }

        // MARK: Functions

        func complete(with result: FeedImageDataLoader.Result) {
            completion?(result)
        }

        func cancel() {
            preventFurtherCompletions()
        }

        private func preventFurtherCompletions() {
            completion = nil
        }
    }

    // MARK: Properties

    private let store: FeedImageDataStore

    // MARK: Lifecycle

    public init(store: FeedImageDataStore) {
        self.store = store
    }

    // MARK: Functions

    public func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void) {
        store.insert(data, for: url) { _ in }
    }

    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        let task = Task(completion)
        store.retrieve(dataForURL: url) { [weak self] result in
            guard self != nil else { return }

            task.complete(with: result
                .mapError { _ in Error.failed }
                .flatMap { data in
                    data.map { .success($0) } ?? .failure(Error.notFound)
                })
        }
        return task
    }
}
