//
//  LoadFeedFromCacheUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Hugo Vanderlei on 25/09/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//

import EssentialFeed
import XCTest

final class LoadFeedFromCacheUseCaseTests: XCTestCase {

    // MARK: Internal

    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_load_requestCacheRetrieval() {
        let (sut, store) = makeSUT()
        sut.load() { _ in }
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let retrievalError = anyNSError()
        
        let exp = expectation(description: "Wait for load completion")
        var receivedError: Error?
        sut.load() { result in
            switch result {
            case let .failure(error):
                receivedError = error
            default:
                XCTFail("Expected failure, got \(String(describing: result)) instead")
            }
            
            exp.fulfill()
        }
        
        store.completeRetrieval(with: retrievalError)
        XCTAssertEqual(receivedError as NSError? , receivedError as NSError?)
        wait(for: [exp], timeout: 1.0)
    }
    
//    func test_load_deliversNoImagesOnEmptyCache() {
//        let (sut, store) = makeSUT()
//        let retrievalError = anyNSError()
//        
//        let exp = expectation(description: "Wait for load completion")
//        var receivedImages: [FeedImage]?
//        sut.load() { result in
//            
//            switch result {
//            case let .success(feedImages):
//                receivedImages = feedImages
//                
//            default:
//                XCTFail("Expected success, got \(String(describing: result)) instead")
//            }
//        
//            
//            
//            exp.fulfill()
//        }
//        
//        
//        store.completeRetrieval(with: retrievalError)
//        
//        
//        XCTAssertEqual(receivedError as NSError? , receivedError as NSError?)
//        
//        wait(for: [exp], timeout: 1
//    }

    // MARK: Private

    private func makeSUT(
        currentDate: @escaping () -> Date = Date.init,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }

}
