//
//  FeedLoaderPresentationAdapter.swift
//  EssentialFeediOS
//
//  Created by Hugo Vanderlei on 27/11/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import EssentialFeed

final class FeedLoaderPresentationAdapter: FeedViewControllerDelegate {

    // MARK: Properties

    var presenter: FeedPresenter?

    private let feedLoader: FeedLoader

    // MARK: Lifecycle

    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }

    // MARK: Functions

    func didRequestFeedRefresh() {
        presenter?.didStartLoadingFeed()

        feedLoader.load { [weak self] result in
            switch result {
            case let .success(feed):
                self?.presenter?.didFinishLoadingFeed(with: feed)

            case let .failure(error):
                self?.presenter?.didFinishLoadingFeed(with: error)
            }
        }
    }
}
