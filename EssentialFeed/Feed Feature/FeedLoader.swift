//
//  Copyright © Essential Developer. All rights reserved.
//

import Foundation

// MARK: - LoadFeedResult

public enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}

// MARK: - FeedLoader

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
