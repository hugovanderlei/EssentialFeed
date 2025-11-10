//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Hugo Vanderlei on 10/11/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import EssentialFeed
import Foundation
import UIKit

final class FeedImageViewModel {

    // MARK: Nested Types

    typealias Observer<T> = (T) -> Void

    // MARK: Properties

    var onImageLoad: Observer<UIImage>?
    var onImageLoadingStateChange: Observer<Bool>?
    var onShouldRetryImageLoadStateChange: Observer<Bool>?

    private var task: FeedImageDataLoaderTask?
    private let model: FeedImage
    private let imageLoader: FeedImageDataLoader

    // MARK: Computed Properties

    var description: String? {
        return model.description
    }

    var location: String? {
        return model.location
    }

    var hasLocation: Bool {
        return location != nil
    }

    // MARK: Lifecycle

    init(model: FeedImage, imageLoader: FeedImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }

    // MARK: Functions

    func loadImageData() {
        onImageLoadingStateChange?(true)
        onShouldRetryImageLoadStateChange?(false)
        task = imageLoader.loadImageData(from: model.url) { [weak self] result in
            self?.handle(result)
        }
    }

    func cancelImageDataLoad() {
        task?.cancel()
        task = nil
    }

    private func handle(_ result: FeedImageDataLoader.Result) {
        if let image = (try? result.get()).flatMap(UIImage.init) {
            onImageLoad?(image)
        } else {
            onShouldRetryImageLoadStateChange?(true)
        }
        onImageLoadingStateChange?(false)
    }

}
