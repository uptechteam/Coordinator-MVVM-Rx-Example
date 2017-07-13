//
//  RepositoryListViewModelTests.swift
//  RepoSearcher
//
//  Created by Arthur Myronenko on 7/12/17.
//  Copyright © 2017 UPTech Team. All rights reserved.
//

@testable import RepoSearcher
import XCTest
import RxTest
import RxSwift

class RepositoryListViewModelTests: XCTestCase {

    let testRepository = Repository(fullName: "Full Name",
                                    description: "Description",
                                    starsCount: 3,
                                    url: "https://www.apple.com")

    var testScheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var githubService: GithubServiceMock!
    var viewModel: RepositoryListViewModel!

    override func setUp() {
        super.setUp()

        testScheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        githubService = GithubServiceMock()
        viewModel = RepositoryListViewModel(initialLanguage: "Swift", githubService: githubService)
    }

    func test_InitWithInitialLanguage_EmitsValidTitle() {
        viewModel = RepositoryListViewModel(initialLanguage: "Swift", githubService: githubService)
        let result = testScheduler.start { self.viewModel.title }
        XCTAssertEqual(result.events, [next(200, "Swift")])
    }

    func test_InitWithInitialLanguage_SendsValidRequest() {
        viewModel = RepositoryListViewModel(initialLanguage: "Swift", githubService: githubService)

        testScheduler.createHotObservable([next(300, ())])
            .bind(to: viewModel.reload)
            .disposed(by: disposeBag)

        let result = testScheduler.start { self.viewModel.repositories }
        XCTAssertEqual(result.events.count, 0)
        XCTAssertEqual("Swift", githubService.repositoriesLanguageArgument)
    }

    func test_Repositories_ReturnsValidViewModels() {
        let testRepository = Repository(fullName: "Full Name",
                                        description: "Description",
                                        starsCount: 3,
                                        url: "https://www.apple.com")
        githubService.repositoriesReturnValue = .just([testRepository])

        testScheduler.createHotObservable([next(300, ())])
            .bind(to: viewModel.reload)
            .disposed(by: disposeBag)

        let result = testScheduler.start { self.viewModel.repositories }
        XCTAssertEqual(result.events.count, 1)

        guard let repositoryViewModel = result.events.first?.value.element?.first else {
            return XCTFail()
        }

        XCTAssertEqual(repositoryViewModel.name, "Full Name")
    }

    func test_RepositoriesWithNetworkError_EmitsAlertMessage() {
        let error = NSError(domain: "Test", code: 2, userInfo: nil)
        githubService.repositoriesReturnValue = .error(error)

        testScheduler.createHotObservable([next(300, ())])
            .bind(to: viewModel.reload)
            .disposed(by: disposeBag)

        viewModel.repositories
            .subscribe()
            .disposed(by: disposeBag)

        let result = testScheduler.start { self.viewModel.alertMessage }
        XCTAssertEqual(result.events, [next(300, error.localizedDescription)])
    }

    func test_LanguageChange_UpdatesRepositories() {
        githubService.repositoriesReturnValue = .just([testRepository])

        testScheduler.createHotObservable([next(300, ())])
            .bind(to: viewModel.reload)
            .disposed(by: disposeBag)

        testScheduler.createHotObservable([next(400, "Objective-C")])
            .bind(to: viewModel.setCurrentLanguage)
            .disposed(by: disposeBag)

        let result = testScheduler.start { self.viewModel.repositories.map({ _ in true }) }
        XCTAssertEqual(result.events, [next(300, true), next(400, true)])
    }

    func test_SelectRepository_EmitsShowRepository() {
        let repositoryToSelect = RepositoryViewModel(repository: testRepository)
        let selectRepositoryObservable = testScheduler.createHotObservable([next(300, repositoryToSelect)])

        selectRepositoryObservable
            .bind(to: viewModel.selectRepository)
            .disposed(by: disposeBag)

        let result = testScheduler.start { self.viewModel.showRepository.map { $0.absoluteString } }
        XCTAssertEqual(result.events, [next(300, "https://www.apple.com")])
    }

    func test_ChooseLanguage_EmitsShowLanguageList() {
        testScheduler.createHotObservable([next(300, ())])
            .bind(to: viewModel.chooseLanguage)
            .disposed(by: disposeBag)

        let result = testScheduler.start { self.viewModel.showLanguageList.map({ true }) }
        XCTAssertEqual(result.events, [next(300, true)])
    }
}
