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

// MARK: - SceneDelegate

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: Properties

    var window: UIWindow?

    // MARK: Functions

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }

        let remoteURL = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!

        let remoteClient = makeRemoteClient()
        let remoteFeedLoader = RemoteFeedLoader(url: remoteURL, client: remoteClient)
        let remoteImageLoader = RemoteFeedImageDataLoader(client: remoteClient)

        let localStoreURL = NSPersistentContainer
            .defaultDirectoryURL()
            .appendingPathComponent("feed-store.sqlite")
        #if DEBUG
            if CommandLine.arguments.contains("-reset") {
                try? FileManager.default.removeItem(at: localStoreURL)
            }
        #endif

        let localStore = try! CoreDataFeedStore(storeURL: localStoreURL)
        let localFeedLoader = LocalFeedLoader(store: localStore, currentDate: Date.init)
        let localImageLoader = LocalFeedImageDataLoader(store: localStore)

        window?.rootViewController = FeedUIComposer.feedComposedWith(
            feedLoader: FeedLoaderWithFallbackComposite(
                primary: FeedLoaderCacheDecorator(
                    decoratee: remoteFeedLoader,
                    cache: localFeedLoader
                ),
                fallback: localFeedLoader
            ),
            imageLoader: FeedImageDataLoaderWithFallbackComposite(
                primary: localImageLoader,
                fallback: FeedImageDataLoaderCacheDecorator(
                    decoratee: remoteImageLoader,
                    cache: localImageLoader
                )
            )
        )
    }

    private func makeRemoteClient() -> HTTPClient {
        #if DEBUG
            if UserDefaults.standard.string(forKey: "connectivity") == "offline" {
                return AlwaysFailingHTTPClient()
            }
        #endif

        return URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }

}

// MARK: - AlwaysFailingHTTPClient

#if DEBUG
    private class AlwaysFailingHTTPClient: HTTPClient {

        // MARK: Nested Types

        private class Task: HTTPClientTask {
            func cancel() {}
        }

        // MARK: Functions

        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
            completion(.failure(NSError(domain: "offline", code: 0)))
            return Task()
        }
    }
#endif
