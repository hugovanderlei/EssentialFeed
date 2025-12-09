//
//  FeedPresenterTests.swift
//  EssentialFeedTests
//
//  Created by Hugo Vanderlei on 09/12/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import XCTest

// MARK: - FeedErrorViewModel

struct FeedErrorViewModel {

    // MARK: Static Computed Properties

    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: nil)
    }

    // MARK: Properties

    let message: String?

}

// MARK: - FeedErrorView

protocol FeedErrorView {
    func display(_ viewModel: FeedErrorViewModel)
}

// MARK: - FeedPresenter

final class FeedPresenter {

    // MARK: Properties

    private let errorView: FeedErrorView

    // MARK: Lifecycle

    init(errorView: FeedErrorView) {
        self.errorView = errorView
    }

    // MARK: Functions

    func didStartLoadingFeed() {
        errorView.display(.noError)
    }
}

// MARK: - FeedPresenterTests

final class FeedPresenterTests: XCTestCase {

    // MARK: Nested Types

    private class ViewSpy: FeedErrorView {

        // MARK: Nested Types

        enum Message: Equatable {
            case display(errorMessage: String?)
        }

        // MARK: Properties

        private(set) var messages = [Message]()

        // MARK: Functions

        func display(_ viewModel: FeedErrorViewModel) {
            messages.append(.display(errorMessage: viewModel.message))
        }
    }

    // MARK: Functions

    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()

        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }

    func test_didStartLoadingFeed_displaysNoErrorMessage() {
        let (sut, view) = makeSUT()

        sut.didStartLoadingFeed()

        XCTAssertEqual(view.messages, [.display(errorMessage: .none)])
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedPresenter(errorView: view)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }

}
