//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import EssentialFeed
import UIKit
import XCTest

// MARK: - FeedViewController

final class FeedViewController: UITableViewController {

    // MARK: Properties

    private var loader: FeedLoader?

    // MARK: Lifecycle

    convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        load()
    }
    
    @objc private func load() {
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
        let (_, loader) = makeSUT()

        XCTAssertEqual(loader.loadCallCount, 0)
    }

    func test_viewDidLoad_loadsFeed() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()

        XCTAssertEqual(loader.loadCallCount, 1)
    }
    
    func test_pullToRefresh_loadsFeed() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        sut.refreshControl?.allTargets.forEach { target in
            sut.refreshControl?.actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }

        XCTAssertEqual(loader.loadCallCount, 2)
    }

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedViewController(loader: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }

}
