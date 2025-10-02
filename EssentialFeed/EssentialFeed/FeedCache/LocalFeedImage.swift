//
//  LocalFeedItem.swift
//  EssentialFeed
//
//  Created by Hugo Vanderlei on 25/09/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//
import Foundation

public struct LocalFeedImage: Equatable {

    // MARK: Properties

    // MARK: Public

    public let id: UUID
    public let description: String?
    public let location: String?
    public let url: URL

    // MARK: Lifecycle

    public init(id: UUID, description: String?, location: String?, url: URL) {
        self.id = id
        self.description = description
        self.location = location
        self.url = url
    }

}
