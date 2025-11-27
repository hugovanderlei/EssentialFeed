//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Hugo Vanderlei on 06/11/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//
import EssentialFeed
import UIKit

// MARK: - FeedUIComposer

public final class FeedUIComposer {

    // MARK: Lifecycle

    private init() {}

    // MARK: Static Functions

    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        let presentationAdapter = FeedLoaderPresentationAdapter(feedLoader:
            MainQueueDispatchDecorator(decoratee: feedLoader))

        let feedController = FeedViewController.makeWith(
            delegate: presentationAdapter,
            title: FeedPresenter.title
        )

        presentationAdapter.presenter = FeedPresenter(
            feedView: FeedViewAdapter(
                controller: feedController,
                imageLoader: MainQueueDispatchDecorator(decoratee: imageLoader)
            ),
            loadingView: WeakRefVirtualProxy(feedController)
        )

        return feedController
    }
}

private extension FeedViewController {
    static func makeWith(delegate: FeedViewControllerDelegate, title: String) -> FeedViewController {
        let bundle = Bundle(for: FeedViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! FeedViewController
        feedController.delegate = delegate
        feedController.title = title
        return feedController
    }
}

// MARK: - FeedViewAdapter

private final class FeedViewAdapter: FeedView {

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

