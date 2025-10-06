//
//  ManagedCache.swift
//  EssentialFeed
//
//  Created by Hugo Vanderlei on 06/10/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import CoreData

// MARK: - ManagedCache

@objc(ManagedCache)
class ManagedCache: NSManagedObject {

    @NSManaged var timestamp: Date
    @NSManaged var feed: NSOrderedSet
}

extension ManagedCache {
    // MARK: Static Functions

    static func find(in context: NSManagedObjectContext) throws -> ManagedCache? {
        let request = NSFetchRequest<ManagedCache>(entityName: entity().name!)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request).first
    }

    static func newUniqueInstance(in context: NSManagedObjectContext) throws -> ManagedCache {
        try find(in: context).map(context.delete)
        return ManagedCache(context: context)
    }

    var localFeed: [LocalFeedImage] {
        return feed.compactMap { ($0 as? ManagedFeedImage)?.local }
    }

}
