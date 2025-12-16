//
//  CoreDataFeedStore.swift
//  EssentialFeedTests
//
//  Created by Hugo Vanderlei on 03/10/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import CoreData

public final class CoreDataFeedStore {

    // MARK: Nested Types

    enum StoreError: Error {
        case modelNotFound
        case failedToLoadPersistentContainer(Error)
    }

    // MARK: Static Properties

    private static let modelName = "FeedStore"
    private static let model = NSManagedObjectModel.with(name: modelName, in: Bundle(for: CoreDataFeedStore.self))

    // MARK: Properties

    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext

    // MARK: Lifecycle

    public init(storeURL: URL) throws {
        guard let model = CoreDataFeedStore.model else {
            throw StoreError.modelNotFound
        }

        do {
            container = try NSPersistentContainer.load(name: CoreDataFeedStore.modelName, model: model, url: storeURL)
            context = container.newBackgroundContext()
        } catch {
            throw StoreError.failedToLoadPersistentContainer(error)
        }
    }

    deinit {
        cleanUpReferencesToPersistentStores()
    }

    // MARK: Functions

    func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }

    private func cleanUpReferencesToPersistentStores() {
        context.performAndWait {
            let coordinator = self.container.persistentStoreCoordinator
            try? coordinator.persistentStores.forEach(coordinator.remove)
        }
    }

}
