//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by Hugo Vanderlei on 12/11/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import EssentialFeed
import Foundation

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

    // MARK: Static Computed Properties

    static var title: String {
        return NSLocalizedString(
            "FEED_VIEW_TITLE",
            tableName: "Feed",
            bundle: Bundle(for: FeedPresenter.self),
            comment: "Title for the feed view"
        )
    }

    // MARK: Properties

    private let feedView: FeedView
    private let loadingView: FeedLoadingView

    // MARK: Lifecycle

    init(feedView: FeedView, loadingView: FeedLoadingView) {
        self.feedView = feedView
        self.loadingView = loadingView
    }

    // MARK: Functions

    func didStartLoadingFeed() {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async { [weak self] in self?.didStartLoadingFeed() }
        }

        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }

    func didFinishLoadingFeed(with feed: [FeedImage]) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async { [weak self] in self?.didFinishLoadingFeed(with: feed) }
        }

        feedView.display(FeedViewModel(feed: feed))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }

    func didFinishLoadingFeed(with error: Error) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async { [weak self] in self?.didFinishLoadingFeed(with: error) }
        }
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
}
