//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Hugo Vanderlei on 04/11/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import UIKit
// MARK: - FeedRefreshViewController

final class FeedRefreshViewController: NSObject, FeedLoadingView {

    // MARK: Properties

//    lazy var view = binded(UIRefreshControl())
    lazy var view = loadView()

    private let presenter: FeedPresenter

    // MARK: Lifecycle

    init(presenter: FeedPresenter) {
        self.presenter = presenter
    }

    private func loadView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }

    // MARK: Functions

    func display(isLoading: Bool) {
        if isLoading {
            view.beginRefreshing()
        } else {
            view.endRefreshing()
        }
    }

    @objc func refresh() {
        presenter.loadFeed()
    }

}

