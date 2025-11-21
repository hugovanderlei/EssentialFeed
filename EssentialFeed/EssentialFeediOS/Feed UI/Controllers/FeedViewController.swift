//
//  FeedImageDataLoaderTask.swift
//  EssentialFeed
//
//  Created by Hugo Vanderlei on 04/11/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import UIKit

// MARK: - FeedViewControllerDelegate

protocol FeedViewControllerDelegate {
    func didRequestFeedRefresh()
}

// MARK: - FeedViewController

public final class FeedViewController: UITableViewController, UITableViewDataSourcePrefetching, FeedLoadingView {

    // MARK: Properties

    var delegate: FeedViewControllerDelegate?

    var tableModel = [FeedImageCellController]() {
        didSet { tableView.reloadData() }
    }

    private var viewAppeared = false

    // MARK: Lifecycle

    override public func viewDidLoad() {
        super.viewDidLoad()
        refresh()
    }

    // MARK: Overridden Functions

    override public func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)

        if !viewAppeared {
            refreshControl?.beginRefreshing()
            viewAppeared = true
        }
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view()
    }

    override public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelCellControllerLoad(forRowAt: indexPath)
    }

    // MARK: Functions

    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            cellController(forRowAt: indexPath).preload()
        }
    }

    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelCellControllerLoad)
    }

    func display(_ viewModel: FeedLoadingViewModel) {
        if viewModel.isLoading {
            refreshControl?.beginRefreshing()
        } else {
            refreshControl?.endRefreshing()
        }
    }

    @IBAction private func refresh() {
        delegate?.didRequestFeedRefresh()
    }

    private func cellController(forRowAt indexPath: IndexPath) -> FeedImageCellController {
        return tableModel[indexPath.row]
    }

    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
        cellController(forRowAt: indexPath).cancelLoad()
    }

}
