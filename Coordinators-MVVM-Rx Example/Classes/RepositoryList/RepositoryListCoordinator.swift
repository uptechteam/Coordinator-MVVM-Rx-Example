//
//  RepositoryListCoordinator.swift
//  Coordinators-MVVM-Rx Example
//
//  Created by Arthur Myronenko on 6/30/17.
//  Copyright © 2017 Arthur Myronenko. All rights reserved.
//

import UIKit
import RxSwift
import SafariServices

class RepositoryListCoordinator: BaseCoordinator<Void> {

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    override func start() -> Observable<Void> {
        let viewModel = RepositoryListViewModel()
        let viewController = UIStoryboard(name: "Main", bundle: Bundle.main)
            .instantiateViewController(withIdentifier: "RepositoryListViewController") as! RepositoryListViewController
        let navigationController = UINavigationController(rootViewController: viewController)

        viewController.viewModel = viewModel

        viewModel.showRepository
            .subscribe(onNext: { [weak self ] in self?.showRepository(by: $0, in: navigationController)  })
            .disposed(by: disposeBag)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        return Observable.never()
    }

    private func showRepository(by url: URL, in navigationController: UINavigationController) {
        let safariViewController = SFSafariViewController(url: url)
        navigationController.pushViewController(safariViewController, animated: true)
    }
}
