//
//  LocalFeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Hugo Vanderlei on 12/12/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import Foundation

// MARK: - LocalFeedImageDataLoader

public final class LocalFeedImageDataLoader {

    // MARK: Properties

    private let store: FeedImageDataStore

    // MARK: Lifecycle

    public init(store: FeedImageDataStore) {
        self.store = store
    }
}

public extension LocalFeedImageDataLoader {
    typealias SaveResult = Result<Void, Error>

    func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void) {
        store.insert(data, for: url) { result in
            completion(.failure(SaveError.failed))
        }
    }
}

// MARK: FeedImageDataLoader

extension LocalFeedImageDataLoader: FeedImageDataLoader {
    public typealias LoadResult = FeedImageDataLoader.Result

    public enum LoadError: Error {
        case failed
        case notFound
    }

    public enum SaveError: Error {
        case failed
    }

    private final class LoadImageDataTask: FeedImageDataLoaderTask {

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

    public func loadImageData(from url: URL, completion: @escaping (LoadResult) -> Void) -> FeedImageDataLoaderTask {
        let task = LoadImageDataTask(completion)
        store.retrieve(dataForURL: url) { [weak self] result in
            guard self != nil else { return }

            task.complete(with: result
                .mapError { _ in LoadError.failed }
                .flatMap { data in
                    data.map { .success($0) } ?? .failure(LoadError.notFound)
                })
        }
        return task
    }

}
