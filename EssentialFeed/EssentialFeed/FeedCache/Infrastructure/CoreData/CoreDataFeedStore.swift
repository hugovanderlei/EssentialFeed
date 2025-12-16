//
//  CoreDataFeedStore.swift
//  EssentialFeedTests
//
//  Created by Hugo Vanderlei on 03/10/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import CoreData
import Foundation

// MARK: - CoreDataFeedStore

public final class CoreDataFeedStore: FeedStore {

    // MARK: Properties

    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext

    // MARK: Lifecycle

    public init(storeURL: URL, bundle: Bundle = .main) throws {
        container = try NSPersistentContainer.load(modelName: "FeedStore", url: storeURL, in: bundle)
        context = container.newBackgroundContext()
    }

    // MARK: Functions

    public func retrieve(completion: @escaping RetrievalCompletion) {
        perform { context in
            completion(Result {
                try ManagedCache.find(in: context).map {
                    CachedFeed(
                        feed: $0.localFeed,
                        timestamp: $0.timestamp
                    )
                }

            })
        }
    }

    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        perform { context in
            completion(Result {
                let managedCache = try ManagedCache.newUniqueInstance(in: context)
                managedCache.timestamp = timestamp
                managedCache.feed = ManagedFeedImage.images(from: feed, in: context)
                try context.save()
            })
        }
    }

    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        perform { context in
            completion(Result {
                try ManagedCache.find(in: context).map(context.delete).map(context.save)

            })
        }
    }

    func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }

}
