//
//  CommentsViewController.swift
//  TestTask
//
//  Created by Oleh Mykytyn on 17.12.2022.
//

import Foundation
import UIKit

protocol CommentsViewControllerProtocol: AnyObject {
    func insertRows(at indexPaths: [IndexPath])
    func showTableFooterSpinner()
    func hideTableFooterSpinner()
}

final class CommentsViewController: UIViewController, CommentsViewControllerProtocol {
    // MARK: - Properties
    private var viewModel: CommentsViewModelProtocol
    private var tableView = UITableView()
    private let tableFooterSpinner: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()

    // MARK: - Life cycle
    init(viewModel: CommentsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        setupUI()
        viewModel.loadInitialComments()
    }

    // MARK: - Internal methods
    func insertRows(at indexPaths: [IndexPath]) {
        tableView.insertRows(at: indexPaths, with: .fade)
    }

    func showTableFooterSpinner() {
        tableFooterSpinner.startAnimating()
    }

    func hideTableFooterSpinner() {
        tableFooterSpinner.stopAnimating()
    }

    // MARK: - Private methods
    private func layout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupUI() {
        navigationItem.title = "Comments"
        navigationItem.largeTitleDisplayMode = .automatic

        view.backgroundColor = .systemBackground

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(handleCloseButtonTap)
        )

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: .zero, left: 8, bottom: .zero, right: 8)
        tableView.allowsSelection = false
        tableView.tableFooterView = tableFooterSpinner
        tableView.register(CommentCell .self, forCellReuseIdentifier: CommentCell.reuseIdentifier)
    }

    @objc private func handleCloseButtonTap() {
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CommentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CommentCell.reuseIdentifier,
            for: indexPath
        ) as? CommentCell else {
            fatalError("Failed to dequeue CommentCell")
        }

        let comment = viewModel.comments[indexPath.row]
        cell.configure(comment: comment)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.comments.count - 1 {
            viewModel.loadNextPageIfNeeded()
        }
    }
}
