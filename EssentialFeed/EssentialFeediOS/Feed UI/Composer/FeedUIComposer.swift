//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Hugo Vanderlei on 06/11/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//
import EssentialFeed
import UIKit

public final class FeedUIComposer {

    // MARK: Lifecycle

    private init() {}

    // MARK: Static Functions

    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        let refreshController = FeedRefreshViewController(feedLoader: feedLoader)
        let feedController = FeedViewController(refreshController: refreshController)
        refreshController.onRefresh = { [weak feedController] feed in
            feedController?.tableModel = feed.map { model in
                FeedImageCellController(model: model, imageLoader: imageLoader)
            }
        }

        return feedController
    }
}
