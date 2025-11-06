//
//  FeedImageDataLoaderTask.swift
//  EssentialFeed
//
//  Created by Hugo Vanderlei on 04/11/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import EssentialFeed
import UIKit

// MARK: - FeedViewController

public final class FeedViewController: UITableViewController, UITableViewDataSourcePrefetching {

    // MARK: Properties

    var refreshController: FeedRefreshViewController?

    private var viewAppeared = false
    private var cellControllers = [IndexPath: FeedImageCellController]()
    private var imageLoader: FeedImageDataLoader?

    private var tableModel = [FeedImage]() {
        didSet { tableView.reloadData() }
    }

    // MARK: Lifecycle

    override public func viewDidLoad() {
        super.viewDidLoad()

        refreshController?.onRefresh = { [weak self] feed in
            self?.tableModel = feed
        }
        tableView.prefetchDataSource = self
        refreshControl = refreshController?.view
        refreshController?.refresh()
    }

    convenience init(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) {
        self.init()
        refreshController = FeedRefreshViewController(feedLoader: feedLoader)
        self.imageLoader = imageLoader
    }

    // MARK: Overridden Functions

    override public func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)

        if !viewAppeared {
            refresh()
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
        removeCellController(forRowAt: indexPath)
    }

    // MARK: Functions

    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            cellController(forRowAt: indexPath).preload()
        }
    }

    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(removeCellController)
    }

    func refresh() {
        refreshControl?.beginRefreshing()
    }

    private func cellController(forRowAt indexPath: IndexPath) -> FeedImageCellController {
        let cellModel = tableModel[indexPath.row]
        let cellController = FeedImageCellController(model: cellModel, imageLoader: imageLoader!)
        cellControllers[indexPath] = cellController
        return cellController
    }

    private func removeCellController(forRowAt indexPath: IndexPath) {
        cellControllers[indexPath] = nil
    }

}
