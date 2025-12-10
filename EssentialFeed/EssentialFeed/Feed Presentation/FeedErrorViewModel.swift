//
//  FeedErrorViewModel.swift
//  EssentialFeed
//
//  Created by Hugo Vanderlei on 10/12/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

public struct FeedErrorViewModel {

    // MARK: Static Computed Properties

    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: nil)
    }

    // MARK: Properties

    public let message: String?

    // MARK: Static Functions

    static func error(message: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(message: message)
    }

}
