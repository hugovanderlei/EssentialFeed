//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Hugo Vanderlei on 10/11/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import EssentialFeed
import Foundation

final class FeedImageViewModel<Image>  {

    // MARK: Nested Types

    typealias Observer<T> = (T) -> Void
    private let imageTransformer: (Data) -> Image?


    // MARK: Properties

    var onImageLoad: Observer<Image>?
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

    init(model: FeedImage, imageLoader: FeedImageDataLoader, imageTransformer: @escaping (Data) -> Image?) {
        self.model = model
        self.imageLoader = imageLoader
        self.imageTransformer = imageTransformer
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
        if let image = (try? result.get()).flatMap(imageTransformer) {
            onImageLoad?(image)
        } else {
            onShouldRetryImageLoadStateChange?(true)
        }
        onImageLoadingStateChange?(false)
    }

}
