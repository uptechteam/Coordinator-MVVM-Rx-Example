//
//  RepositoryListViewModel.swift
//  Coordinators-MVVM-Rx Example
//
//  Created by Arthur Myronenko on 6/29/17.
//  Copyright © 2017 Arthur Myronenko. All rights reserved.
//

import Foundation
import RxSwift

class RepositoryListViewModel {

    // MARK: - Inputs

    let setCurrentLanguage: AnyObserver<String>
    let selectRepository: AnyObserver<RepositoryViewModel>

    // MARK: - Outputs

    let repositories: Observable<[RepositoryViewModel]>
    let title: Observable<String>
    let showRepository: Observable<URL>

    init(githubService: GithubService = GithubService()) {
        let _currentLanguage = BehaviorSubject<String>(value: "Swift")
        self.setCurrentLanguage = _currentLanguage.asObserver()
        self.title = _currentLanguage.asObservable()
            .map { "Most Popular: \($0)" }

        self.repositories = _currentLanguage.asObservable()
            .flatMapLatest { githubService.getMostPopularRepositories(byLanguage: $0) }
            .map { repositories in repositories.map(RepositoryViewModel.init) }

        let _selectRepository = PublishSubject<RepositoryViewModel>()
        self.selectRepository = _selectRepository.asObserver()
        self.showRepository = _selectRepository.asObservable()
            .map { $0.url }
    }
}
