//
//  GithubService.swift
//  Coordinators-MVVM-Rx Example
//
//  Created by Arthur Myronenko on 6/29/17.
//  Copyright © 2017 Arthur Myronenko. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class GithubService {

    private let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func getLanguageList() -> Observable<[String]> {
        return Observable.just([
            "Swift",
            "Objective-C",
            "Java",
            "C",
            "C++",
            "Python",
            "C#"
            ])
    }

    func getMostPopularRepositories(byLanguage language: String) -> Observable<[Repository]> {
        let encodedLanguage = language.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url = URL(string: "https://api.github.com/search/repositories?q=language:\(encodedLanguage)&sort=stars")!
        return session.rx
            .json(url: url)
            .flatMap { json throws -> Observable<[Repository]> in
                guard
                    let json = json as? [String: Any],
                    let itemsJSON = json["items"] as? [Any]
                else { return Observable.error(NSError(domain: "Network Error", code: 1, userInfo: nil)) }

                let repositories: [Repository]
                do {
                    let itemsData = try JSONSerialization.data(withJSONObject: itemsJSON, options: [])
                    repositories = try JSONDecoder().decode([Repository].self, from: itemsData)
                } catch {
                    return Observable.error(error)
                }

                return Observable.just(repositories)
            }
    }
}
