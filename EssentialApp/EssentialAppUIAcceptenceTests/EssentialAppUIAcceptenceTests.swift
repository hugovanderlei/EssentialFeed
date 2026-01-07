//
//  EssentialAppUIAcceptenceTests.swift
//  EssentialAppUIAcceptenceTests
//
//  Created by Hugo Vanderlei on 06/01/26.
//

import XCTest

final class EssentialAppUIAcceptenceTests: XCTestCase {
    
    func test_onLaunch_displaysRemoteFeedWhenCustomerHasConnectivity() {
        let app = XCUIApplication()
        
        app.launch()
        
//        let feedCells = app.cells.matching(identifier: "FeedImageCell")
        XCTAssertEqual(app.cells.count, 22)
        
        let firstImage = app.images.matching(identifier: "FeedImageView").firstMatch
        XCTAssertTrue(firstImage.exists)
    }
}
