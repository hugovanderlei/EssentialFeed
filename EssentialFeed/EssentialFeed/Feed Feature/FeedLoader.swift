//
//  Copyright © 2018 Essential Developer. All rights reserved.
//

import Foundation

// MARK: - LoadFeedResult

public typealias LoadFeedResult = Result<[FeedImage], Error>

// MARK: - FeedLoader

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
