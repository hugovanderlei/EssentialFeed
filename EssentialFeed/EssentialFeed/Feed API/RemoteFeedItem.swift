//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Hugo Vanderlei on 25/09/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//
import Foundation

struct RemoteFeedItem: Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
}
