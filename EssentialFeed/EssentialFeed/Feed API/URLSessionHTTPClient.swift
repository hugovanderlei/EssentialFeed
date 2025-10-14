//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import Foundation

public class URLSessionHTTPClient: HTTPClient {

    // MARK: Nested Types

    private struct UnexpectedValuesRepresentation: Error {}

    // MARK: Properties

    private let session: URLSession

    // MARK: Lifecycle

    public init(session: URLSession = .shared) {
        self.session = session
    }

    // MARK: Functions

    public func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        session.dataTask(with: url) { data, response, error in
            completion(Result {
                if let error = error {
                    throw error
                } else if let data = data, let response = response as? HTTPURLResponse {
                    return (data, response)
                } else {
                    throw UnexpectedValuesRepresentation()
                }
            })

        }.resume()
    }
}
