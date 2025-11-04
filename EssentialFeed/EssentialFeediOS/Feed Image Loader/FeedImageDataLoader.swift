//
//  FeedImageDataLoader.swift
//  EssentialFeediOS
//
//  Created by Hugo Vanderlei on 04/11/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import Foundation

// MARK: - FeedImageDataLoaderTask

public protocol FeedImageDataLoaderTask {
    func cancel()
}

// MARK: - FeedImageDataLoader

public protocol FeedImageDataLoader {
    typealias Result = Swift.Result<Data, Error>

    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> FeedImageDataLoaderTask
}
