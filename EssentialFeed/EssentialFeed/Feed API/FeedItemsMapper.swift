//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import Foundation

// MARK: - Item

internal struct RemoteFeedItem: Decodable {
    internal let id: UUID
    internal let description: String?
    internal let location: String?
    internal  let image: URL
}

// MARK: - FeedItemsMapper

internal final class FeedItemsMapper {

    // MARK: Internal

    internal static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard response.statusCode == OK_200,
              let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteFeedLoader.Error.invalidData
        }

        return root.items
    }

    // MARK: Private

    private struct Root: Decodable {
        let items: [RemoteFeedItem]

    }

    private static var OK_200: Int { return 200 }

}
