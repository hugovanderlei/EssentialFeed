//
//  LocalFeedLoader.swift
//  EssentialFeed
//
//  Created by Hugo Vanderlei on 24/09/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//
import Foundation

// MARK: - LocalFeedLoader

public final class LocalFeedLoader {

    // MARK: Lifecycle

    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }

    // MARK: Public

    public typealias SaveResult = Error?

    public func save(_ items: [FeedItem], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedFeed { [weak self] error in
            guard let self else { return }
            if let cacheDeletionError = error {
                completion(cacheDeletionError)
            } else {
                self.cache(items, with: completion)
            }
        }
    }

    // MARK: Internal

    let store: FeedStore

    // MARK: Private

    private let currentDate: () -> Date

    private func cache(_ items: [FeedItem], with completion: @escaping (SaveResult) -> Void) {
        store.insert(items.toLocal(), timestamp: currentDate()) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }

}

private extension Array where Element == FeedItem {
    func toLocal() -> [LocalFeedItem] {
        return map { LocalFeedItem(
            id: $0.id,
            description: $0.description,
            location: $0.location,
            imageURL: $0.imageURL
        ) }
    }
}
