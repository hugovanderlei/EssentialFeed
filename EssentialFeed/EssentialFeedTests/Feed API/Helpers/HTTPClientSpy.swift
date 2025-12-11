//
//  HTTPClientSpy.swift
//  EssentialFeed
//
//  Created by Hugo Vanderlei on 11/12/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import EssentialFeed
import Foundation

class HTTPClientSpy: HTTPClient {

    // MARK: Nested Types

    private struct Task: HTTPClientTask {

        // MARK: Properties

        let callback: () -> Void

        // MARK: Functions

        func cancel() { callback() }
    }

    // MARK: Properties

    private(set) var cancelledURLs = [URL]()

    private var messages = [(url: URL, completion: (HTTPClient.Result) -> Void)]()

    // MARK: Computed Properties

    var requestedURLs: [URL] {
        return messages.map { $0.url }
    }

    // MARK: Functions

    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        messages.append((url, completion))
        return Task { [weak self] in
            self?.cancelledURLs.append(url)
        }
    }

    func complete(with error: Error, at index: Int = 0) {
        messages[index].completion(.failure(error))
    }

    func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
        let response = HTTPURLResponse(
            url: requestedURLs[index],
            statusCode: code,
            httpVersion: nil,
            headerFields: nil
        )!
        messages[index].completion(.success((data, response)))
    }
}
