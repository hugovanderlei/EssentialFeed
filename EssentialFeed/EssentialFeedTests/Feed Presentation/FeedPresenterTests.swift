//
//  FeedPresenterTests.swift
//  EssentialFeedTests
//
//  Created by Hugo Vanderlei on 09/12/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import XCTest

// MARK: - FeedPresenter

final class FeedPresenter {
    init(view: Any) {}
}

// MARK: - FeedPresenterTests

final class FeedPresenterTests: XCTestCase {

    // MARK: Nested Types

    private class ViewSpy {
        let messages = [Any]()
    }

    // MARK: Functions

    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()

        _ = FeedPresenter(view: view)

        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedPresenter(view: view)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }
    

}
