//
//  Copyright © 2018 Essential Developer. All rights reserved.
//

import Foundation

// MARK: - LoadFeedResult

public enum LoadFeedResult {
    case success([FeedImage])
    case failure(Error)
}

// MARK: - FeedLoader

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
