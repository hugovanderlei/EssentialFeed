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

    // MARK: Lifecycle

    public init() {}

    // MARK: Functions

    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {}

    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {}

    public func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.empty)
    }

}

// MARK: - ManagedCache

private class ManagedCache: NSManagedObject {
    @NSManaged var timestamp: Date
    @NSManaged var feed: NSOrderedSet
}

// MARK: - ManagedFeedImage

private class ManagedFeedImage: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var imageDescription: String?
    @NSManaged var location: String?
    @NSManaged var url: URL
    @NSManaged var cache: ManagedCache
}
