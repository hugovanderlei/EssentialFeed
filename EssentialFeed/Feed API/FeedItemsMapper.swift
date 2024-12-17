//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Hugo Vanderlei on 09/12/24.
//

import Foundation

enum FeedItemsMapper {

    // MARK: Internal

    static func map(_ data: Data, _ response: HTTPURLResponse) -> RemoteFeedLoader.Result {
        guard response.statusCode == OK_200,
              let root = try? JSONDecoder().decode(Root.self, from: data) else {
            return .failure(RemoteFeedLoader.Error.invalidData)
        }

        return .success(root.feed)
    }

    // MARK: Private

    // MARK: - Root

    private struct Root: Decodable {
        let items: [Item]

        var feed: [FeedItem] {
            return items.map { $0.item }
        }
    }

    // MARK: - Item

    private struct Item: Decodable {
        let id: UUID
        let description: String?
        let location: String?
        let image: URL

        var item: FeedItem {
            return FeedItem(
                id: id,
                description: description,
                location: location,
                imageURL: image
            )
        }
    }

    private static var OK_200: Int { return 200 }

}
