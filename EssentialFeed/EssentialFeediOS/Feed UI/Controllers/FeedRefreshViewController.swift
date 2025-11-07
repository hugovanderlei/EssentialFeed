//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Hugo Vanderlei on 04/11/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import UIKit

final class FeedRefreshViewController: NSObject {

    // MARK: Properties

    lazy var view = binded(UIRefreshControl())

    private let viewModel: FeedViewModel

    // MARK: Lifecycle

    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Functions

    @objc func refresh() {
        viewModel.loadFeed()
    }

    private func binded(_ view: UIRefreshControl) -> UIRefreshControl {
        viewModel.onChange = { [weak self] viewModel in
            if viewModel.isLoading {
                self?.view.beginRefreshing()
            } else {
                self?.view.endRefreshing()
            }
        }
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
