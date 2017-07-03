//
//  LanguageListViewModel.swift
//  Coordinators-MVVM-Rx Example
//
//  Created by Arthur Myronenko on 6/30/17.
//  Copyright © 2017 Arthur Myronenko. All rights reserved.
//

import RxSwift

class LanguageListViewModel {

    // MARK: - Inputs

    let languages: Observable<[String]>
    let didSelectLanguage: Observable<String>
    let didCancel: Observable<Void>

    // MARK: - Outputs

    let selectLanguage: AnyObserver<String>
    let cancel: AnyObserver<Void>

    init(githubService: GithubService = GithubService()) {
        self.languages = githubService.getLanguageList()

        let _selectLanguage = PublishSubject<String>()
        self.selectLanguage = _selectLanguage.asObserver()
        self.didSelectLanguage = _selectLanguage.asObservable()

        let _cancel = PublishSubject<Void>()
        self.cancel = _cancel.asObserver()
        self.didCancel = _cancel.asObservable()
    }
}
