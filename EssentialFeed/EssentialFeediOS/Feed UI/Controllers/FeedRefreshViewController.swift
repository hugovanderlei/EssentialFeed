//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Hugo Vanderlei on 04/11/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import EssentialFeed
import UIKit

final class FeedRefreshViewController: NSObject {

    // MARK: Properties

    public lazy var view: UIRefreshControl = {
         let view = UIRefreshControl()
         view.addTarget(self, action: #selector(refresh), for: .valueChanged)
         return view
     }()
     

    var onRefresh: (([FeedImage]) -> Void)?

    private let feedLoader: FeedLoader

    // MARK: Lifecycle

    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }

    // MARK: Functions

    @objc func refresh() {
        view.beginRefreshing()
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.onRefresh?(feed)
            }
            self?.view.endRefreshing()
        }
    }
}
