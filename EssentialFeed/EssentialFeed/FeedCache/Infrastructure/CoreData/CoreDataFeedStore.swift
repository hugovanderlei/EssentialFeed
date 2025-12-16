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

public final class CoreDataFeedStore {

    // MARK: Properties

    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext

    // MARK: Lifecycle

    public init(storeURL: URL) throws {
        let bundle = Bundle(for: CoreDataFeedStore.self)
        container = try NSPersistentContainer.load(modelName: "FeedStore", url: storeURL, in: bundle)
        context = container.newBackgroundContext()
    }

    // MARK: Functions

    func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }

}
