//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import EssentialFeed
import UIKit
import XCTest

// MARK: - FeedViewController

final class FeedViewController: UITableViewController {

    // MARK: Properties

    private var viewAppeared = false

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

    // MARK: Overridden Functions

    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)

        if !viewAppeared {
            refresh()
            viewAppeared = true
        }
    }

    // MARK: Functions

    func refresh() {
        refreshControl?.beginRefreshing()
    }

    @objc private func load() {
        refresh()
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
        let (sut, _) = makeSUT()

        sut.simulateAppearance()
        XCTAssertEqual(sut.refreshControl?.isRefreshing, true)
//
//        sut.refreshControl?.endRefreshing()
//        sut.refreshControl?.sendActions(for: .valueChanged)
//        XCTAssertEqual(sut.refreshControl?.isRefreshing, true)
        
        sut.refreshControl?.endRefreshing()
        sut.simulateAppearance()
        XCTAssertEqual(sut.refreshControl?.isRefreshing, false)
        
        
    }

    func test_viewDidLoad_showsLoadingIndicator() {
        let (sut, _) = makeSUT()

        sut.simulateAppearance()
        XCTAssertEqual(sut.refreshControl?.isRefreshing, true)
    }

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedViewController(loader: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }

}

private extension FeedViewController {
    func replaceRefreshControlWithFakeForiOS17Support() {
        let fake = FakeRefreshControl()

        refreshControl?.allTargets.forEach { target in
            refreshControl?.actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                action in
                fake.addTarget(target, action: Selector(action), for: .valueChanged)
            }
        }
        refreshControl = fake
    }

    func simulateAppearance() {
        if !isViewLoaded {
            loadViewIfNeeded()
            replaceRefreshControlWithFakeForiOS17Support()
        }
        beginAppearanceTransition(true, animated: false)
        endAppearanceTransition()
    }
}

// MARK: - FakeRefreshControl

private class FakeRefreshControl: UIRefreshControl {

    // MARK: Overridden Properties

    override var isRefreshing: Bool { _isRefreshing }

    // MARK: Properties

    private var _isRefreshing = false

    // MARK: Overridden Functions

    override func beginRefreshing() {
        _isRefreshing = true
    }

    override func endRefreshing() {
        _isRefreshing = false
    }
}
