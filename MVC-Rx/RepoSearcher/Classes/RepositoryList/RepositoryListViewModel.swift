//
//  RepositoryListViewModel.swift
//  RepoSearcher
//
//  Created by Arthur Myronenko on 6/29/17.
//  Copyright © 2017 UPTech Team. All rights reserved.
//

import Foundation
import RxSwift

class RepositoryListViewModel {

    // MARK: - Inputs

    let setCurrentLanguage: AnyObserver<String>
    let chooseLanguage: AnyObserver<Void>
    let selectRepository: AnyObserver<RepositoryViewModel>

    // MARK: - Outputs

    let repositories: Observable<[RepositoryViewModel]>
    let title: Observable<String>
    let alert: Observable<String>
    let showRepository: Observable<URL>
    let showLanguageList: Observable<Void>

    init(githubService: GithubService = GithubService()) {
        let _currentLanguage = BehaviorSubject<String>(value: "Swift")
        self.setCurrentLanguage = _currentLanguage.asObserver()
        self.title = _currentLanguage.asObservable()
            .map { "Most Popular: \($0)" }

        let _alert = PublishSubject<String>()
        self.alert = _alert.asObservable()

//        self.repositories = _currentLanguage.asObservable()
//            .flatMapLatest {
//                githubService.getMostPopularRepositories(byLanguage: $0)
//                    .catchError { error in
//                        _alert.onNext(error.localizedDescription)
//                        return Observable.empty()
//                    }
//            }
//            .map { repositories in repositories.map(RepositoryViewModel.init) }
        self.repositories = .empty()

        let _selectRepository = PublishSubject<RepositoryViewModel>()
        self.selectRepository = _selectRepository.asObserver()
        self.showRepository = _selectRepository.asObservable()
            .map { $0.url }

        let _chooseLanguage = PublishSubject<Void>()
        self.chooseLanguage = _chooseLanguage.asObserver()
        self.showLanguageList = _chooseLanguage.asObservable()
    }
}
