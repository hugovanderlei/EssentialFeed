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


    var feedView: FeedView?
    var loadingView: FeedLoadingView?

    func didStartLoadingFeed() {
        loadingView?.display(FeedLoadingViewModel(isLoading: true))
    }

    func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView?.display(FeedViewModel(feed: feed))
        loadingView?.display(FeedLoadingViewModel(isLoading: false))
    }

    func didFinishLoadingFeed(with error: Error) {
        loadingView?.display(FeedLoadingViewModel(isLoading: false))
    }
}
