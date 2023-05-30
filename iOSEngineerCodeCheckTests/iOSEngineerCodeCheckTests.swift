//
//  iOSEngineerCodeCheckTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import XCTest
@testable import iOSEngineerCodeCheck

class iOSEngineerCodeCheckTests: XCTestCase {
    var networkManager: SearchNetworkManager?
    
    let testRepoName = "test_name"
    let testLanguage = "test_language"
    let testStarsCount = 100
    let testWatchersCount = 10
    let testForksCount = 5
    let testOpenIssuesCount = 1
    let testImageURLString = "https://api.github.com/test.png"
    
    let testJSONString = #"""
    {
        "items": [
            {
                "full_name": "test_name",
                "language": "test_language",
                "owner": {
                    "avatar_url": "https://api.github.com/test.png",
                },
                "stargazers_count": 100,
                "watchers_count": 10,
                "forks_count": 5,
                "open_issues_count": 1,
            }
        ]
    }
    """#
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        networkManager = SearchNetworkManager()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSearchRequest() throws {
        let expectation = XCTestExpectation(description: "Search Request")
        let searchWord = "test"
        networkManager?.requestSearchList(searchWord) { listModel, error in
            XCTAssertNil(error)
            XCTAssertNotNil(listModel)
            expectation.fulfill()
        }
        let result = XCTWaiter().wait(for: [expectation], timeout: 3.0)
        XCTAssert(result == .completed, "Search Request Time Out!")
    }
    
    func testSearchListModel() throws {
        if let listModel = try? JSONDecoder().decode(SearchListModel.self, from: testJSONString.data(using: .utf8)!) {
            let repo = listModel.repoModels.first
            XCTAssertNotNil(repo)
            XCTAssertEqual(repo?.fullName, testRepoName)
            XCTAssertEqual(repo?.language, testLanguage)
            XCTAssertEqual(repo?.starsCount, testStarsCount)
            XCTAssertEqual(repo?.watchersCount, testWatchersCount)
            XCTAssertEqual(repo?.forksCount, testForksCount)
            XCTAssertEqual(repo?.openIssuesCount, testOpenIssuesCount)
            XCTAssertNotNil(repo?.owner)
            XCTAssertEqual(repo?.owner?.avatarURLString, testImageURLString)
        } else {
            XCTAssertTrue(false, "JSON decode failed!")
        }
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
