//
//  XCTest+MemoryLeakTracking.swift
//  EssentialFeed
//
//  Created by Hugo Vanderlei on 08/01/25.
//

import XCTest

extension XCTestCase {

    func trackForMemoryLeaks(
        _ instance: AnyObject,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(
                instance,
                "Instance should have been deallocated, Potential memory leak",
                file: file,
                line: line
            )
        }
    }
}
