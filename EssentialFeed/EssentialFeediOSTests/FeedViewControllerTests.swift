//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by Hugo Vanderlei on 17/10/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import XCTest

// MARK: - FeedViewController

final class FeedViewController {

    // MARK: Properties

    var loader: FeedViewControllerTests.LoaderSpy

    // MARK: Lifecycle

    init(loader: FeedViewControllerTests.LoaderSpy) {
        self.loader = loader
    }

}

// MARK: - FeedViewControllerTests

final class FeedViewControllerTests: XCTestCase {

    // MARK: Nested Types

    class LoaderSpy {

        private(set) var loaderCallCount: Int = 0
    }

    // MARK: Functions

    func test_init_doesNotLoadFeed() {
        let loader = LoaderSpy()
        let _ = FeedViewController(loader: loader)

        XCTAssertEqual(loader.loaderCallCount, 0)
    }

}
