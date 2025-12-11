//
//  RemoteFeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Hugo Vanderlei on 11/12/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import Foundation

public final class RemoteFeedImageDataLoader: FeedImageDataLoader {

    // MARK: Nested Types

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    private final class HTTPClientTaskWrapper: FeedImageDataLoaderTask {

        // MARK: Properties

        var wrapped: HTTPClientTask?

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
            wrapped?.cancel()
        }

        private func preventFurtherCompletions() {
            completion = nil
        }
    }

    // MARK: Properties

    private let client: HTTPClient

    // MARK: Lifecycle

    public init(client: HTTPClient) {
        self.client = client
    }

    // MARK: Functions

    @discardableResult
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        let task = HTTPClientTaskWrapper(completion)
        task.wrapped = client.get(from: url) { [weak self] result in
            guard self != nil else { return }

            task.complete(with: result
                .mapError { _ in Error.connectivity }
                .flatMap { data, response in
                    let isValidResponse = response.statusCode == 200 && !data.isEmpty
                    return isValidResponse ? .success(data) : .failure(Error.invalidData)
                })
        }
        return task
    }
}
