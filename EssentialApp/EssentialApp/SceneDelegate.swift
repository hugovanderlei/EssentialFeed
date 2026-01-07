//
//  SceneDelegate.swift
//  EssentialApp
//
//  Created by Hugo Vanderlei on 16/12/25.
//

import CoreData
import EssentialFeed
import EssentialFeediOS
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: Properties

    var window: UIWindow?

    // MARK: Functions

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }

        let remoteUrl = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!

        let remoteClient = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        let remoteFeedLoader = RemoteFeedLoader(url: remoteUrl, client: remoteClient)
        let remoteImageLoader = RemoteFeedImageDataLoader(client: remoteClient)

        window?.rootViewController = FeedUIComposer.feedComposedWith(
            feedLoader: remoteFeedLoader,
            imageLoader: remoteImageLoader
        )

//        let localStoreURL = NSPersistentContainer
//            .defaultDirectoryURL()
//            .appendingPathComponent("feed-store.sqlite")
//
//        let localStore = try! CoreDataFeedStore(storeURL: localStoreURL)
//        let localFeedLoader = LocalFeedLoader(store: localStore, currentDate: Date.init)
//        let localImageLoader = LocalFeedImageDataLoader(store: localStore)
//
//        let feedViewController = FeedUIComposer.feedComposedWith(
//            feedLoader: FeedLoaderWithFallbackComposite(
//                primary: FeedLoaderCacheDecorator(
//                    decoratee: remoteFeedLoader,
//                    cache: localFeedLoader
//                ),
//                fallback: localFeedLoader
//            ),
//            imageLoader: FeedImageDataLoaderWithFallbackComposite(
//                primary: localImageLoader,
//                fallback: FeedImageDataLoaderCacheDecorator(
//                    decoratee: remoteImageLoader,
//                    cache: localImageLoader
//                )
//            )
//        )

//        window?.rootViewController = feedViewController
    }

}
