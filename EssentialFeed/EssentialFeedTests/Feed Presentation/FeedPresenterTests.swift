//
//  FeedPresenterTests.swift
//  EssentialFeedTests
//
//  Created by Hugo Vanderlei on 09/12/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import XCTest

// MARK: - FeedLoadingViewModel

struct FeedLoadingViewModel {
    let isLoading: Bool
}

// MARK: - FeedLoadingView

protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel)
}

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
    private let loadingView: FeedLoadingView

    // MARK: Lifecycle

    init(loadingView: FeedLoadingView, errorView: FeedErrorView) {
        self.errorView = errorView
        self.loadingView = loadingView
    }

    // MARK: Functions

    func didStartLoadingFeed() {
        errorView.display(.noError)
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }
}

// MARK: - FeedPresenterTests

final class FeedPresenterTests: XCTestCase {

    // MARK: Nested Types

    private class ViewSpy: FeedErrorView, FeedLoadingView {

        // MARK: Nested Types

        enum Message: Hashable {
            case display(errorMessage: String?)
            case display(isLoading: Bool)
        }

        // MARK: Properties

        private(set) var messages = Set<Message>()

        // MARK: Functions

        func display(_ viewModel: FeedErrorViewModel) {
            messages.insert(.display(errorMessage: viewModel.message))
        }

        func display(_ viewModel: FeedLoadingViewModel) {
            messages.insert(.display(isLoading: viewModel.isLoading))
        }
    }

    // MARK: Functions

    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()

        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }

    func test_didStartLoadingFeed_displaysNoErrorMessageAndStartsLoading() {
        let (sut, view) = makeSUT()

        sut.didStartLoadingFeed()

        XCTAssertEqual(view.messages, [
            .display(errorMessage: .none),
            .display(isLoading: true)
        ])
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedPresenter(loadingView: view, errorView: view)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }

}
