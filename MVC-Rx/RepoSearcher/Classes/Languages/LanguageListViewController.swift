//
//  LanguageListViewController.swift
//  RepoSearcher
//
//  Created by Arthur Myronenko on 6/30/17.
//  Copyright © 2017 UPTech Team. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/// Shows a list languages.
class LanguageListViewController: UIViewController {

    let disposeBag = DisposeBag()

    private let _cancel = PublishSubject<Void>()
    var didCancel: Observable<Void> { return _cancel.asObservable() }

    private let _selectLanguage = PublishSubject<String>()
    var didSelectLanguage: Observable<String> { return _selectLanguage.asObservable() }

    @IBOutlet private weak var tableView: UITableView!
    let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)

    private let githubService = GithubService()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBindings()
    }

    private func setupUI() {
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.title = "Choose a language"

        tableView.rowHeight = 48.0
    }

    private func setupBindings() {
        let languages = githubService.getLanguageList()
        languages
            .bind(to: tableView.rx.items(cellIdentifier: "LanguageCell", cellType: UITableViewCell.self)) { (_, language, cell) in
                cell.textLabel?.text = language
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)

        tableView.rx.modelSelected(String.self)
            .bind(to: _selectLanguage)
            .disposed(by: disposeBag)

        cancelButton.rx.tap
            .bind(to: _cancel)
            .disposed(by: disposeBag)
    }
}
