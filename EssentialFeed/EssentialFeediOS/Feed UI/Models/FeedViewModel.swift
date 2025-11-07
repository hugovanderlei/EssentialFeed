//
//  FeedViewModel.swift
//  EssentialFeediOS
//
//  Created by Hugo Vanderlei on 07/11/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import EssentialFeed
import Foundation

final class FeedViewModel {
    typealias Observer<T> = (T) -> Void

    // MARK: Properties

    var onLoadingStateChange: Observer<Bool>?
    var onFeedLoad: Observer<[FeedImage]>?


    private let feedLoader: FeedLoader

    // MARK: Lifecycle

    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }

    // MARK: Functions

    func loadFeed() {
        onLoadingStateChange?(true)
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.onFeedLoad?(feed)
            }
            self?.onLoadingStateChange?(false)
        }
    }
}
