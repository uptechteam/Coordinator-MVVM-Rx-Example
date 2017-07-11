//
//  LanguageListViewController.swift
//  RepoSearcher
//
//  Created by Arthur Myronenko on 6/30/17.
//  Copyright © 2017 UPTech Team. All rights reserved.
//

import UIKit

protocol LanguageListViewControllerDelegate: class {
    func languageListViewController(_ viewController: LanguageListViewController, didSelectLanguage language: String)
    func languageListViewControllerDidCancel(_ viewController: LanguageListViewController)
}

class LanguageListViewController: UIViewController {

    weak var delegate: LanguageListViewControllerDelegate?

    @IBOutlet private weak var tableView: UITableView!

    private let githubService = GithubService()
    fileprivate var languages = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

        setupUI()
        loadData()
    }

    private func setupUI() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.title = "Choose a language"

        tableView.rowHeight = 48.0
    }

    private func loadData() {
        githubService.getLanguageList { [weak self] result in
            guard case let .success(newLanguages) = result else { return }
            self?.languages = newLanguages
            self?.tableView.reloadData()
        }
    }

    @objc
    private func cancel() {
        delegate?.languageListViewControllerDidCancel(self)
    }
}

extension LanguageListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath)
        let language = languages[indexPath.row]
        cell.textLabel?.text = language
        cell.selectionStyle = .none
        return cell
    }
}

extension LanguageListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let language = languages[indexPath.row]
        delegate?.languageListViewController(self, didSelectLanguage: language)
    }
}
