//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Hugo Vanderlei on 04/11/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import UIKit

// MARK: - FeedRefreshViewControllerDelegate

protocol FeedRefreshViewControllerDelegate {
    func didRequestFeedRefresh()
}

// MARK: - FeedRefreshViewController

final class FeedRefreshViewController: NSObject, FeedLoadingView {

    // MARK: Properties

    lazy var view = loadView()

    private let delegate: FeedRefreshViewControllerDelegate

    // MARK: Lifecycle

    init(delegate: FeedRefreshViewControllerDelegate) {
        self.delegate = delegate
    }

    private func loadView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }

    // MARK: Functions

    func display(_ viewModel: FeedLoadingViewModel) {
        if viewModel.isLoading {
            view.beginRefreshing()
        } else {
            view.endRefreshing()
        }
    }

    @objc func refresh() {
        delegate.didRequestFeedRefresh()
    }

}
