//
//  FeedErrorViewModel.swift
//  EssentialFeediOS
//
//  Created by Hugo Vanderlei on 09/12/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//
struct FeedErrorViewModel {

    // MARK: Static Computed Properties

    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: nil)
    }

    // MARK: Properties

    let message: String?

    // MARK: Static Functions

    static func error(message: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(message: message)
    }
}
