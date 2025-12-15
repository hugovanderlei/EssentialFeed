//
//  ManagedFeedImage.swift
//  EssentialFeed
//
//  Created by Hugo Vanderlei on 06/10/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import CoreData

// MARK: - ManagedFeedImage

@objc(ManagedFeedImage)
class ManagedFeedImage: NSManagedObject {

    // MARK: Properties

    @NSManaged var id: UUID
    @NSManaged var imageDescription: String?
    @NSManaged var location: String?
    @NSManaged var url: URL
    @NSManaged var cache: ManagedCache
    @NSManaged var data: Data?

    // MARK: Computed Properties

    var local: LocalFeedImage {
        return LocalFeedImage(
            id: id,
            description: imageDescription,
            location: location,
            url: url
        )
    }

}

extension ManagedFeedImage {
    // MARK: Static Functions

    static func images(from localFeed: [LocalFeedImage], in context: NSManagedObjectContext) -> NSOrderedSet {
        return NSOrderedSet(array: localFeed.map { local in
            let managed = ManagedFeedImage(context: context)
            managed.id = local.id
            managed.imageDescription = local.description
            managed.location = local.location
            managed.url = local.url
            return managed
        })
    }
}
