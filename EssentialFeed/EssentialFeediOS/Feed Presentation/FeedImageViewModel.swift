//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Hugo Vanderlei on 10/11/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//
struct FeedImageViewModel<Image> {

    // MARK: Properties

    let description: String?
    let location: String?
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool

    // MARK: Computed Properties

    var hasLocation: Bool {
        return location != nil
    }
}
