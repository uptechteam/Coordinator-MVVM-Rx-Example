//
//  RepositoryViewModelTests.swift
//  RepoSearcherTests
//
//  Created by Arthur Myronenko on 7/11/17.
//  Copyright © 2017 UPTech Team. All rights reserved.
//

@testable import RepoSearcher
import XCTest

class RepositoryViewModelTests: XCTestCase {

    let repository = Repository(fullName: "Full Name",
                                description: "Description",
                                starsCount: 3,
                                url: "https://www.apple.com")

    var repositoryViewModel: RepositoryViewModel!

    override func setUp() {
        super.setUp()

        repositoryViewModel = RepositoryViewModel(repository: repository)
    }
    
    func test_Name_ReturnsRepositoryFullName() {
        XCTAssertEqual(repositoryViewModel.name, "Full Name")
    }

    func test_Description_ReturnsRepositoryDescription() {
        XCTAssertEqual(repositoryViewModel.description, "Description")
    }

    func test_StarsCountText_ReturnsCorrectlyFormatedString() {
        XCTAssertEqual(repositoryViewModel.starsCountText, "⭐️ 3")
    }

    func test_URL_ReturnsRepositoryURL() {
        XCTAssertEqual(repositoryViewModel.url.absoluteString, "https://www.apple.com")
    }
}
