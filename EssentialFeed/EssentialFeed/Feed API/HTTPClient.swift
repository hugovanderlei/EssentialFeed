//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import Foundation

// MARK: - HTTPClientResult

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

// MARK: - HTTPClient

public protocol HTTPClient {

    /// The completion handler can be invoked in any thread
    /// Clients are responsible to dispatch to appropiate thread, if needed
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
