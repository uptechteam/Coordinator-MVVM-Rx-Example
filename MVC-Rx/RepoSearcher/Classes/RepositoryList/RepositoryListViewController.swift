//
//  RepositoryListViewController.swift
//  RepoSearcher
//
//  Created by Arthur Myronenko on 6/29/17.
//  Copyright © 2017 UPTech Team. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SafariServices

/// Shows a list of most starred repositories filtered by language.
class RepositoryListViewController: UIViewController {

    private enum SegueType: String {
        case languageList = "Show Language List"
    }

    @IBOutlet private weak var tableView: UITableView!
    private let chooseLanguageButton = UIBarButtonItem(barButtonSystemItem: .organize, target: nil, action: nil)
    private let refreshControl = UIRefreshControl()

    private let githubService = GithubService()
    private let disposeBag = DisposeBag()

    fileprivate var currentLanguage = BehaviorSubject(value: "Swift")

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBindings()


        refreshControl.sendActions(for: .valueChanged)
    }

    private func setupUI() {
        navigationItem.rightBarButtonItem = chooseLanguageButton

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.insertSubview(refreshControl, at: 0)
    }

    private func setupBindings() {
        // Refresh control reload events
        let reload = refreshControl.rx.controlEvent(.valueChanged)
            .asObservable()

        // Fires a request to the github service every time reload or currentLanguage emits an item.
        // Emits an array of repositories -  result of request.
        let repositories = Observable.combineLatest(reload.startWith().debug(), currentLanguage.debug()) { _, language in return language }
            .debug()
            .flatMap { [unowned self] in
                self.githubService.getMostPopularRepositories(byLanguage: $0)
                    .observeOn(MainScheduler.instance)
                    .catchError { error in
                        self.presentAlert(message: error.localizedDescription)
                        return .empty()
                    }
            }
            .do(onNext: { [weak self] _ in self?.refreshControl.endRefreshing() })

        // Bind repositories to the table view as a data source.
        repositories
            .bind(to: tableView.rx.items(cellIdentifier: "RepositoryCell", cellType: RepositoryCell.self)) { [weak self] (_, repo, cell) in
                self?.setupRepositoryCell(cell, repository: repo)
            }
            .disposed(by: disposeBag)

        // Bind current language to the navigation bar title.
        currentLanguage
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)

        // Subscribe on cell selection of the table view and call `openRepository` on every item.
        tableView.rx.modelSelected(Repository.self)
            .subscribe(onNext: { [weak self] in self?.openRepository($0) })
            .disposed(by: disposeBag)

        // Subscribe on thaps of che `chooseLanguageButton` and call `openLanguageList` on every item.
        chooseLanguageButton.rx.tap
            .subscribe(onNext: { [weak self] in self?.openLanguageList() })
            .disposed(by: disposeBag)
    }

    private func setupRepositoryCell(_ cell: RepositoryCell, repository: Repository) {
        cell.selectionStyle = .none
        cell.setName(repository.fullName)
        cell.setDescription(repository.description)
        cell.setStarsCountTest("⭐️ \(repository.starsCount)")
    }

    private func presentAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }

    // MARK: - Navigation

    private func openRepository(_ repository: Repository) {
        let url = URL(string: repository.url)!
        let safariViewController = SFSafariViewController(url: url)
        navigationController?.pushViewController(safariViewController, animated: true)
    }

    private func openLanguageList() {
        performSegue(withIdentifier: SegueType.languageList.rawValue, sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationVC: UIViewController? = segue.destination

        if let nvc = destinationVC as? UINavigationController {
            destinationVC = nvc.viewControllers.first
        }

        if let viewController = destinationVC as? LanguageListViewController, segue.identifier == SegueType.languageList.rawValue {
            prepareLanguageListViewController(viewController)
        }
    }

    /// Subscribes on `LanguageListViewController` observables befor navigation.
    ///
    /// - Parameter viewController: `LanguageListViewController` to prepare.
    private func prepareLanguageListViewController(_ viewController: LanguageListViewController) {
        let dismiss = Observable.merge([
            viewController.didCancel,
            viewController.didSelectLanguage.map { _ in }
            ])

        dismiss
            .subscribe(onNext: { [weak self] in self?.dismiss(animated: true) })
            .disposed(by: viewController.disposeBag)

        viewController.didSelectLanguage
            .bind(to: currentLanguage)
            .disposed(by: viewController.disposeBag)
    }
}
