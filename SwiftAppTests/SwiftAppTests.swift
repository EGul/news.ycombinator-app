//
//  SwiftAppTests.swift
//  SwiftAppTests
//
//  Created by sarah on 10/28/15.
//  Copyright © 2015 none. All rights reserved.
//

import XCTest
@testable import SwiftApp

class SwiftAppTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNewsAPI() {
        
        let expectation = self.expectationWithDescription("get data")
        
        let newsAPI = NewsAPI()
        
        newsAPI.getTopStories() { (result: [NSDictionary], error: NSError?) in
            XCTAssertEqual(30, result.count)
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(5, handler: nil)
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
