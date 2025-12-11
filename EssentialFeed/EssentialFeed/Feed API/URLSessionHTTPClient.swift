//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import Foundation

public final class URLSessionHTTPClient: HTTPClient {

    // MARK: Nested Types

    private struct UnexpectedValuesRepresentation: Error {}

    private struct URLSessionTaskWrapper: HTTPClientTask {

        // MARK: Properties

        let wrapped: URLSessionTask

        // MARK: Functions

        func cancel() {
            wrapped.cancel()
        }
    }

    // MARK: Properties

    private let session: URLSession

    // MARK: Lifecycle

    public init(session: URLSession = .shared) {
        self.session = session
    }

    // MARK: Functions

    public func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        let task = session.dataTask(with: url) { data, response, error in
            completion(Result {
                if let error = error {
                    throw error
                } else if let data = data, let response = response as? HTTPURLResponse {
                    return (data, response)
                } else {
                    throw UnexpectedValuesRepresentation()
                }
            })

        }
        task.resume()
        return URLSessionTaskWrapper(wrapped: task)
    }
}
