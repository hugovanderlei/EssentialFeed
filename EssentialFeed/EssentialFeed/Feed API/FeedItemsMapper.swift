//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import Foundation

// MARK: - Item

// MARK: - FeedItemsMapper

enum FeedItemsMapper {

    // MARK: Nested Types

    // MARK: Private

    private struct Root: Decodable {
        let items: [RemoteFeedItem]

    }

    // MARK: Static Computed Properties

    private static var OK_200: Int { return 200 }

    // MARK: Static Functions

    // MARK: Internal

    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteFeedLoader.Error.invalidData
        }

        return root.items
    }

}
