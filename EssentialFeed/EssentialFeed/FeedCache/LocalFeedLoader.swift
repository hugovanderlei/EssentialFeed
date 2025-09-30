//
//  LocalFeedLoader.swift
//  EssentialFeed
//
//  Created by Hugo Vanderlei on 24/09/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//
import Foundation

// MARK: - FeedCachePolicy


// MARK: - LocalFeedLoader

public final class LocalFeedLoader {

    // MARK: Lifecycle

    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }

    // MARK: Internal

    let store: FeedStore

    // MARK: Private


    private let currentDate: () -> Date

}

public extension LocalFeedLoader {

    typealias SaveResult = Error?

    func save(
        _ feed: [FeedImage],
        completion: @escaping (SaveResult) -> Void
    ) {
        store.deleteCachedFeed { [weak self] error in
            guard let self else { return }
            if let cacheDeletionError = error {
                completion(cacheDeletionError)
            } else {
                self.cache(feed, with: completion)
            }
        }
    }

    private func cache(
        _ feed: [FeedImage],
        with completion: @escaping (SaveResult) -> Void
    ) {
        store.insert(feed.toLocal(), timestamp: currentDate()) {
            [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }

}

// MARK: FeedLoader

extension LocalFeedLoader: FeedLoader {

    public typealias LoadResult = LoadFeedResult

    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard let self else { return }

            switch result {
            case let .failure(error):
                completion(.failure(error))

            case let .found(feed, timestamp) where FeedCachePolicy.validate(timestamp, against: currentDate()):
                completion(.success(feed.toModels()))

            case .found, .empty:
                completion(.success([]))
            }
        }
    }

}

public extension LocalFeedLoader {

    func validateCache() {
        store.retrieve { [weak self] result in
            guard let self else { return }

            switch result {
            case .failure:
                self.store.deleteCachedFeed { _ in }

            case let .found(_, timestamp) where !FeedCachePolicy.validate(timestamp, against: currentDate()):
                self.store.deleteCachedFeed { _ in }

            case .empty, .found: break
            }
        }
    }

}

private extension Array where Element == FeedImage {
    func toLocal() -> [LocalFeedImage] {
        return map {
            LocalFeedImage(
                id: $0.id,
                description: $0.description,
                location: $0.location,
                url: $0.url
            )
        }
    }
}

private extension Array where Element == LocalFeedImage {
    func toModels() -> [FeedImage] {
        return map {
            FeedImage(
                id: $0.id,
                description: $0.description,
                location: $0.location,
                url: $0.url
            )
        }
    }
}
