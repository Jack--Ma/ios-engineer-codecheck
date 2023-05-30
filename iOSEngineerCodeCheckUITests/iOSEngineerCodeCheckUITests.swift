//
//  iOSEngineerCodeCheckUITests.swift
//  iOSEngineerCodeCheckUITests
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import XCTest

class iOSEngineerCodeCheckUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSearchRequest() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        app.tables["Empty list"].searchFields["GitHubのリポジトリを検索できるよー"].tap()

        let TKey = app.keyboards.keys["T"]
        TKey.tap()
        let eKey = app.keyboards.keys["e"]
        eKey.tap()
        let sKey = app.keyboards.keys["s"]
        sKey.tap()
        let tKey = app.keyboards.keys["t"]
        tKey.tap()

        app.buttons["search"].tap()
        let expectation = XCTestExpectation(description: "Search Request")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.5)
        XCTAssert(app.tables.cells.count > 0)
        let count = app.tables.cells.count
        let word = app.searchFields.firstMatch.value as? String
        app.tables.cells.element(boundBy: 0).tap()
        app.navigationBars["Repo Detail"].buttons["Repo Search"].tap()
        
        XCTAssertEqual(count, app.tables.cells.count)
        XCTAssertEqual(word, app.searchFields.firstMatch.value as? String)
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
