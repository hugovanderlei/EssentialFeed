//
//  WeakRefVirtualProxy.swift
//  EssentialFeediOS
//
//  Created by Hugo Vanderlei on 27/11/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import UIKit

// MARK: - WeakRefVirtualProxy

final class WeakRefVirtualProxy<T: AnyObject> {

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

// MARK: FeedImageView

extension WeakRefVirtualProxy: FeedImageView where T: FeedImageView, T.Image == UIImage {
    func display(_ model: FeedImageViewModel<UIImage>) {
        object?.display(model)
    }
}

// MARK: FeedErrorView

extension WeakRefVirtualProxy: FeedErrorView where T: FeedErrorView {
    func display(_ viewModel: FeedErrorViewModel) {
        object?.display(viewModel)
    }
}
