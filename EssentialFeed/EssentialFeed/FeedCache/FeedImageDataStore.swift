//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Hugo Vanderlei on 12/12/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import Foundation

public protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>

    func retrieve(dataForURL url: URL, completion: @escaping (Result) -> Void)
}
