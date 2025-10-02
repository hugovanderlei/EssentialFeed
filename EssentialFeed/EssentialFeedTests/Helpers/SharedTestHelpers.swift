//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Hugo Vanderlei on 29/09/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import Foundation

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}
