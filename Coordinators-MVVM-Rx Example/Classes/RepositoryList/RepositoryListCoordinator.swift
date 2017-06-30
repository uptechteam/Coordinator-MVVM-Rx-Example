//
//  RepositoryListCoordinator.swift
//  Coordinators-MVVM-Rx Example
//
//  Created by Arthur Myronenko on 6/30/17.
//  Copyright © 2017 Arthur Myronenko. All rights reserved.
//

import UIKit
import RxSwift

class RepositoryListCoordinator: BaseCoordinator<Void> {

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    override func start() -> Observable<Void> {
        let viewModel = RepositoryListViewModel()
        let viewController = UIStoryboard(name: "Main", bundle: Bundle.main)
            .instantiateViewController(withIdentifier: "RepositoryListViewController") as! RepositoryListViewController
        viewController.viewModel = viewModel

        let navigationController = UINavigationController(rootViewController: viewController)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        return Observable.never()
    }
}
