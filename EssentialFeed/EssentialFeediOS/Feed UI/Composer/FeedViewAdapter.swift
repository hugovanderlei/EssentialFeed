//
//  FeedViewAdapter.swift
//  EssentialFeediOS
//
//  Created by Hugo Vanderlei on 27/11/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import EssentialFeed
import UIKit

final class FeedViewAdapter: FeedView {

    // MARK: Properties

    private weak var controller: FeedViewController?
    private let imageLoader: FeedImageDataLoader

    // MARK: Lifecycle

    init(controller: FeedViewController, imageLoader: FeedImageDataLoader) {
        self.controller = controller
        self.imageLoader = imageLoader
    }

    // MARK: Functions

    func display(_ viewModel: FeedViewModel) {
        controller?.tableModel = viewModel.feed.map { model in
            let adapter = FeedImageDataLoaderPresentationAdapter<WeakRefVirtualProxy<FeedImageCellController>, UIImage>(model: model, imageLoader: imageLoader)
            let view = FeedImageCellController(delegate: adapter)

            adapter.presenter = FeedImagePresenter(
                view: WeakRefVirtualProxy(view),
                imageTransformer: UIImage.init
            )

            return view
        }
    }
}
