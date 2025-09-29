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
    public typealias LoadResult = LoadFeedResult

    public func save(
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

    public func load(completion: @escaping (LoadResult?) -> Void) {
        store.retrieve { result in

            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .empty:
                completion(.success([]))
            case .found(let feed, let timestamp):
                completion(.success(feed.toModels()))

            }

        }
    }

    // MARK: Internal

    let store: FeedStore

    // MARK: Private

    private let currentDate: () -> Date

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

extension Array where Element == FeedImage {
    fileprivate func toLocal() -> [LocalFeedImage] {
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

extension Array where Element == LocalFeedImage {
    fileprivate func toModels() -> [FeedImage] {
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
