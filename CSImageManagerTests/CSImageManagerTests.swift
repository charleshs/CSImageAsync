//
//  CSImageManagerTests.swift
//  CSImageManagerTests
//
//  Created by Charles Hsieh on 2020/4/20.
//  Copyright © 2020 Charles Hsieh. All rights reserved.
//

import XCTest
import UIKit
@testable import CSImageAsync

class CSImageManagerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_asyncLoad() throws {
        let imageView = UIImageView()
        imageView.asyncLoad("https://images.unsplash.com/photo-1587364568825-c83dc9914fe3?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=3334&q=80")
        let promise = expectation(description: "asyncLoad")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            XCTAssertNotNil(imageView.image)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 6.0)
    }
}
