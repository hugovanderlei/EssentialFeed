//
//  FeedImageDataLoaderSpy.swift
//  EssentialApp
//
//  Created by Hugo Vanderlei on 30/12/25.
//

import EssentialFeed
import Foundation

class FeedImageDataLoaderSpy: FeedImageDataLoader {

    // MARK: Nested Types

    private struct Task: FeedImageDataLoaderTask {

        // MARK: Properties

        let callback: () -> Void

        // MARK: Functions

        func cancel() { callback() }
    }

    // MARK: Properties

    private(set) var cancelledURLs = [URL]()

    private var messages = [(url: URL, completion: (FeedImageDataLoader.Result) -> Void)]()

    // MARK: Computed Properties

    var loadedURLs: [URL] {
        return messages.map { $0.url }
    }

    // MARK: Functions

    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        messages.append((url, completion))
        return Task { [weak self] in
            self?.cancelledURLs.append(url)
        }
    }

    func complete(with error: Error, at index: Int = 0) {
        messages[index].completion(.failure(error))
    }

    func complete(with data: Data, at index: Int = 0) {
        messages[index].completion(.success(data))
    }
}
