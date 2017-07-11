//
//  GithubService.swift
//  RepoSearcher
//
//  Created by Arthur Myronenko on 6/29/17.
//  Copyright © 2017 UPTech Team. All rights reserved.
//

import Foundation

enum Result<T> {
    case error(Error)
    case success(T)
}

enum ServiceError: Error {
    case cannotParse
}

/// A service that knows how to perform requests for GitHub data.
class GithubService {

    private let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func getLanguageList(completionHandler: (Result<[String]>) -> Void) {
        // For simplicity we will use a stubbed list of languages.
        let stubbedListOfPopularLanguages = [
            "Swift",
            "Objective-C",
            "Java",
            "C",
            "C++",
            "Python",
            "C#"
        ]

        completionHandler(.success(stubbedListOfPopularLanguages))
    }

    func getMostPopularRepositories(byLanguage language: String, completionHandler: @escaping (Result<[Repository]>) -> Void) {
        let encodedLanguage = language.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url = URL(string: "https://api.github.com/search/repositories?q=language:\(encodedLanguage)&sort=stars")!

        session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completionHandler(.error(error))
                    return
                }

                guard
                    let data = data,
                    let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                    let jsonDict = jsonObject as? [String: Any],
                    let itemsJSON = jsonDict["items"] as? [[String: Any]]
                else {
                    completionHandler(.error(ServiceError.cannotParse))
                    return
                }

                let repositories = itemsJSON.flatMap(Repository.init)
                completionHandler(.success(repositories))
            }
        }.resume()
    }
}
