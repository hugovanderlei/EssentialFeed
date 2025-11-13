//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by Hugo Vanderlei on 12/11/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import EssentialFeed

// MARK: - FeedLoadingViewModel

struct FeedLoadingViewModel {
    let isLoading: Bool
}

// MARK: - FeedViewModel

struct FeedViewModel {
    let feed: [FeedImage]
}

// MARK: - FeedLoadingView

protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel)
}

// MARK: - FeedView

protocol FeedView {
    func display(_ viewModel: FeedViewModel)
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
        loadingView?.display(FeedLoadingViewModel(isLoading: true))
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.feedView?.display(FeedViewModel(feed: feed))
            }
            self?.loadingView?.display(FeedLoadingViewModel(isLoading: false))
        }
    }
}
