//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by Hugo Vanderlei on 12/11/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import EssentialFeed

// MARK: - FeedLoadingView

protocol FeedLoadingView {
    func display(isLoading: Bool)
}

// MARK: - FeedView

protocol FeedView {
    func display(feed: [FeedImage])
}

// MARK: - FeedPresenter

final class FeedPresenter {

    // MARK: Nested Types

    typealias Observer<T> = (T) -> Void

    // MARK: Properties

    var feedView: FeedView?
    var loadingView: FeedLoadingView?

    private let feedLoader: FeedLoader

    // MARK: Lifecycle

    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }

    // MARK: Functions

    func loadFeed() {
        loadingView?.display(isLoading: true)
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.feedView?.display(feed: feed)
            }
            self?.loadingView?.display(isLoading: false)
        }
    }
}
