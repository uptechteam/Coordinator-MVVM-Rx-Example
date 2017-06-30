//
//  RepositoryListViewModel.swift
//  Coordinators-MVVM-Rx Example
//
//  Created by Arthur Myronenko on 6/29/17.
//  Copyright © 2017 Arthur Myronenko. All rights reserved.
//

import RxSwift

class RepositoryListViewModel {

    let setCurrentLanguage: AnyObserver<String>

    let repositories: Observable<[RepositoryViewModel]>
    let title: Observable<String>

    init(githubService: GithubService = GithubService()) {
        let _currentLanguage = BehaviorSubject<String>(value: "Swift")
        self.setCurrentLanguage = _currentLanguage.asObserver()
        self.title = _currentLanguage.asObservable()
            .map { "Most Popular: \($0)" }

        self.repositories = _currentLanguage.asObservable()
            .flatMapLatest { githubService.getMostPopularRepositories(byLanguage: $0) }
            .map { repositories in repositories.map(RepositoryViewModel.init) }
    }
}
