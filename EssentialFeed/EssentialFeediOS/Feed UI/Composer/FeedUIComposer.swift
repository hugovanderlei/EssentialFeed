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
        let presenter = FeedPresenter()
        let presentationAdapter = FeedLoaderPresentationAdapter(feedLoader: feedLoader, presenter: presenter)
        let refreshController = FeedRefreshViewController(loadFeed: presentationAdapter.loadFeed)
        let feedController = FeedViewController(refreshController: refreshController)
        presenter.loadingView = WeakRefVirtualProxy(refreshController)
        presenter.feedView = FeedViewAdapter(controller: feedController, imageLoader: imageLoader)

        return feedController
    }

    private static func adaptFeedToCellControllers(forwardingTo controller: FeedViewController, loader: FeedImageDataLoader) -> ([FeedImage]) -> Void {
        return { [weak controller] feed in
            controller?.tableModel = feed.map { model in
                FeedImageCellController(viewModel: FeedImageViewModel(
                    model: model,
                    imageLoader: loader,
                    imageTransformer: UIImage.init
                ))
            }
        }
    }
}

// MARK: - WeakRefVirtualProxy

private final class WeakRefVirtualProxy<T: AnyObject> {

    // MARK: Properties

    private weak var object: T?

    // MARK: Lifecycle

    init(_ object: T) {
        self.object = object
    }
}

// MARK: FeedLoadingView

extension WeakRefVirtualProxy: FeedLoadingView where T: FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel) {
        object?.display(viewModel)
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
            FeedImageCellController(viewModel:
                FeedImageViewModel(model: model, imageLoader: imageLoader, imageTransformer: UIImage.init))
        }
    }
}

// MARK: - FeedLoaderPresentationAdapter

private final class FeedLoaderPresentationAdapter {

    // MARK: Properties

    private let feedLoader: FeedLoader
    private let presenter: FeedPresenter

    // MARK: Lifecycle

    init(feedLoader: FeedLoader, presenter: FeedPresenter) {
        self.feedLoader = feedLoader
        self.presenter = presenter
    }

    // MARK: Functions

    func loadFeed() {
        presenter.didStartLoadingFeed()

        feedLoader.load { [weak self] result in
            switch result {
            case let .success(feed):
                self?.presenter.didFinishLoadingFeed(with: feed)

            case let .failure(error):
                self?.presenter.didFinishLoadingFeed(with: error)
            }
        }
    }
}
