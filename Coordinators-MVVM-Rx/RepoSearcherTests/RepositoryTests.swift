//
//  RepositoryTests.swift
//  RepoSearcher
//
//  Created by Arthur Myronenko on 7/13/17.
//  Copyright © 2017 UPTech Team. All rights reserved.
//

@testable import RepoSearcher
import XCTest

class RepositoryTests: XCTestCase {

    private let sampleJSON: [String: Any] = [
        "full_name": "Full Name",
        "description": "Description",
        "stargazers_count": 4,
        "html_url": "https://apple.com"
    ]

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_InitFromJSON_AllFieldsAreCorrect() {
        guard let repository = Repository(from: sampleJSON) else {
            return XCTFail()
        }

        XCTAssertEqual(repository.fullName, "Full Name")
        XCTAssertEqual(repository.description, "Description")
        XCTAssertEqual(repository.starsCount, 4)
        XCTAssertEqual(repository.url, "https://apple.com")
    }

    func test_EqualityForEqualRepositories_ReturnsTrue() {
        let repo1 = Repository(fullName: "Full Name", description: "Description", starsCount: 3, url: "https://apple.com")
        let repo2 = Repository(fullName: "Full Name", description: "Description", starsCount: 3, url: "https://apple.com")

        XCTAssertEqual(repo1, repo2)
    }
}
