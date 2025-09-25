//
//  LocalFeedItem.swift
//  EssentialFeed
//
//  Created by Hugo Vanderlei on 25/09/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//
import Foundation

public struct LocalFeedItem: Equatable {

    // MARK: Lifecycle

    public init(id: UUID, description: String?, location: String?, imageURL: URL) {
        self.id = id
        self.description = description
        self.location = location
        self.imageURL = imageURL
    }

    // MARK: Public

    public let id: UUID
    public let description: String?
    public let location: String?
    public let imageURL: URL

}
