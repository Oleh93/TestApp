//
//  CommentCell.swift
//  TestTask
//
//  Created by Oleh Mykytyn on 18.12.2022.
//

import UIKit

final class CommentCell: UITableViewCell {
    // MARK: - Properties
    static let reuseIdentifier = "CommentCell"

    private var idLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .systemGray
        return label
    }()

    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()

    private var emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .systemGray
        return label
    }()

    private var bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .systemGray
        label.numberOfLines = 0
        return label
    }()

    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 3
        return stackView
    }()

    // MARK: - Life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layout()
    }

    // MARK: - Internal methods
    func configure(comment: CommentResponse) {
        idLabel.text = "ID: \(comment.id)"
        nameLabel.text = comment.name
        bodyLabel.text = comment.body
        emailLabel.text = comment.email
    }

    // MARK: - Private methods
    private func layout() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])

        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(bodyLabel)
        stackView.addArrangedSubview(emailLabel)
        stackView.addArrangedSubview(idLabel)
    }
}
