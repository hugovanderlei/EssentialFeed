//
//  Copyright © 2018 Essential Developer. All rights reserved.
//

import Foundation

// MARK: - RemoteFeedLoader

public final class RemoteFeedLoader: FeedLoader {

    // MARK: Nested Types

    // MARK: Public

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    public typealias Result = FeedLoader.Result

    // MARK: Properties

    // MARK: Private

    private let url: URL
    private let client: HTTPClient

    // MARK: Lifecycle

    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    // MARK: Static Functions

    private static func map(_ data: Data, response: HTTPURLResponse) -> Result {
        do {
            let items = try FeedItemsMapper.map(data, from: response)
            return .success(items.toModels())
        } catch {
            return .failure(error)
        }
    }

    // MARK: Functions

    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }

            switch result {
            case let .success(data, response):
                completion(RemoteFeedLoader.map(data, response: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }

}

private extension Array where Element == RemoteFeedItem {
    func toModels() -> [FeedImage] {
        return map { FeedImage(
            id: $0.id,
            description: $0.description,
            location: $0.location,
            url: $0.image
        ) }
    }
}
