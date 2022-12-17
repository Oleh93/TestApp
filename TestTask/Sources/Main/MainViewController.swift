//
//  MainViewController.swift
//  TestTask
//
//  Created by Oleh Mykytyn on 17.12.2022.
//

import UIKit
import IQKeyboardManagerSwift

protocol MainViewControllerProtocol: AnyObject {
    func updateUpperBoundInputViewValidity(isValid: Bool, errorMessage: String?)
    func updateLowerBoundInputViewValidity(isValid: Bool, errorMessage: String?)
}

final class MainViewController: UIViewController, MainViewControllerProtocol {
    // MARK: - Properties
    private lazy var viewModel: MainViewModelProtocol = MainViewModel(viewController: self)

    private var lowerBoundInputView: CustomInputView = {
        let textField = CustomInputView()
        textField.placeholder = "Lower bound"
        textField.keyboardType = .numberPad
        return textField
    }()

    private var upperBoundInputView: CustomInputView = {
        let textField = CustomInputView()
        textField.placeholder = "Upper bound"
        textField.keyboardType = .numberPad
        return textField
    }()

    private var descriptionLabel: InsetLabel = {
        let label = InsetLabel()
        label.text = "Bounds should be between 1 and 500 due to API restrictions"
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .systemGray
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    private var searchButton: UIButton = {
        let button = UIButton()
        button.configuration = .bordered()
        button.setTitle("Search", for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleSearchButtonTap), for: .touchUpInside)
        return button
    }()

    private var labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = .zero
        return stackView
    }()

    private var labelsDescriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        return stackView
    }()

    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 16
        return stackView
    }()

    private var shouldSearchButtonBeEnabled: Bool {
        upperBoundInputView.isValid &&
        upperBoundInputView.text?.isEmpty == false &&
        lowerBoundInputView.isValid &&
        lowerBoundInputView.text?.isEmpty == false
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        setupUI()
    }

    // MARK: - MainViewControllerProtocol
    func updateUpperBoundInputViewValidity(isValid: Bool, errorMessage: String?) {
        upperBoundInputView.isValid = isValid
        upperBoundInputView.errorMessage = errorMessage
    }

    func updateLowerBoundInputViewValidity(isValid: Bool, errorMessage: String?) {
        lowerBoundInputView.isValid = isValid
        lowerBoundInputView.errorMessage = errorMessage
    }
    
    // MARK: - Private methods
    private func layout() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        lowerBoundInputView.translatesAutoresizingMaskIntoConstraints = false
        lowerBoundInputView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        labelsStackView.addArrangedSubview(lowerBoundInputView)

        upperBoundInputView.translatesAutoresizingMaskIntoConstraints = false
        upperBoundInputView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        labelsStackView.addArrangedSubview(upperBoundInputView)

        labelsDescriptionStackView.addArrangedSubview(labelsStackView)
        labelsDescriptionStackView.addArrangedSubview(descriptionLabel)

        stackView.addArrangedSubview(labelsDescriptionStackView)
        stackView.addArrangedSubview(searchButton)
    }

    private func setupUI() {
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title = "Test App"
        view.backgroundColor = .systemBackground

        upperBoundInputView.delegate = self
        lowerBoundInputView.delegate = self
    }

    @objc private func handleSearchButtonTap() {
        guard let lowerBound = lowerBoundInputView.text, let lowerBoundInt = Int(lowerBound),
              let upperBound = upperBoundInputView.text, let upperBoundInt = Int(upperBound)
        else { return }

        let viewModel = CommentsViewModel(lowerBound: lowerBoundInt, upperBound: upperBoundInt)
        let viewController = CommentsViewController(viewModel: viewModel)
        viewModel.viewController = viewController
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
}

// MARK: - CustomInputViewDelegate
extension MainViewController: CustomInputViewDelegate {
    func inputViewTextDidChange(_ inputView: CustomInputView) {
        switch inputView {
        case upperBoundInputView:
            viewModel.validateUpperBoundText(
                upperBoundInputView.text,
                lowerBoundText: lowerBoundInputView.text
            )
        case lowerBoundInputView:
            viewModel.validateLowerBoundText(
                lowerBoundInputView.text,
                upperBoundText: upperBoundInputView.text
            )
        default:
            break
        }

        searchButton.isEnabled = shouldSearchButtonBeEnabled
    }
}
