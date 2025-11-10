//
//  FeedImageCellController.swift
//  EssentialFeediOS
//
//  Created by Hugo Vanderlei on 06/11/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import UIKit

final class FeedImageCellController {

    // MARK: Properties

    private let viewModel: FeedImageViewModel<UIImage>

    // MARK: Lifecycle

    init(viewModel: FeedImageViewModel<UIImage>) {
        self.viewModel = viewModel
    }

    // MARK: Functions

    func view() -> UITableViewCell {
        let cell = binded(FeedImageCell())
        viewModel.loadImageData()
        return cell
    }

    func preload() {
        viewModel.loadImageData()
    }

    func cancelLoad() {
        viewModel.cancelImageDataLoad()
    }

    private func binded(_ cell: FeedImageCell) -> FeedImageCell {
        cell.locationContainer.isHidden = !viewModel.hasLocation
        cell.locationLabel.text = viewModel.location
        cell.descriptionLabel.text = viewModel.description
        cell.onRetry = viewModel.loadImageData

        viewModel.onImageLoad = { [weak cell] image in
            cell?.feedImageView.image = image
        }

        viewModel.onImageLoadingStateChange = { [weak cell] isLoading in
            cell?.feedImageContainer.isShimmering = isLoading
        }

        viewModel.onShouldRetryImageLoadStateChange = { [weak cell] shouldRetry in
            cell?.feedImageRetryButton.isHidden = !shouldRetry
        }

        return cell
    }
}
