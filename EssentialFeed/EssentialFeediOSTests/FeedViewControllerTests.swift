//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import EssentialFeed
import UIKit
import XCTest

// MARK: - FeedViewController

final class FeedViewController: UIViewController {

    // MARK: Properties

    private var loader: FeedLoader?

    // MARK: Lifecycle

    convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loader?.load { _ in }
    }
}

// MARK: - FeedViewControllerTests

final class FeedViewControllerTests: XCTestCase {

    // MARK: Nested Types

    // MARK: - Helpers

    class LoaderSpy: FeedLoader {

        // MARK: Properties

        private(set) var loadCallCount: Int = 0

        // MARK: Functions

        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            loadCallCount += 1
        }

    }

    // MARK: Functions

    func test_init_doesNotLoadFeed() {
        let loader = LoaderSpy()
        _ = FeedViewController(loader: loader)

        XCTAssertEqual(loader.loadCallCount, 0)
    }

    func test_viewDidLoad_loadsFeed() {
        let loader = LoaderSpy()
        let sut = FeedViewController(loader: loader)

        sut.loadViewIfNeeded()

        XCTAssertEqual(loader.loadCallCount, 1)
    }

}
