//
//  FeedImageCell.swift
//  EssentialFeed
//
//  Created by Hugo Vanderlei on 27/10/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import UIKit

public final class FeedImageCell: UITableViewCell {

    // MARK: Properties

    public let locationContainer = UIView()
    public let locationLabel = UILabel()
    public let descriptionLabel = UILabel()
    public let feedImageContainer = UIView()
    public let feedImageView = UIImageView()

    public private(set) lazy var feedImageRetryButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        return button
    }()

    var onRetry: (() -> Void)?

    // MARK: Functions

    @objc private func retryButtonTapped() {
        onRetry?()
    }
}
