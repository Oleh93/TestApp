//
//  CustomInputView.swift
//  TestTask
//
//  Created by Oleh Mykytyn on 17.12.2022.
//

import Foundation
import UIKit

protocol CustomInputViewDelegate: AnyObject {
    func inputViewTextDidChange(_ inputView: CustomInputView)
}

extension CustomInputViewDelegate {
    func inputViewTextDidChange(_ inputView: CustomInputView) { }
}

final class CustomInputView: UIView {
    // MARK: - Properties
    weak var delegate: CustomInputViewDelegate?

    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }

    var placeholder: String? {
        get { textField.placeholder }
        set { textField.placeholder = newValue }
    }

    var keyboardType: UIKeyboardType {
        get { textField.keyboardType }
        set { textField.keyboardType = newValue }
    }

    var isValid: Bool = true {
        didSet { updateValidity() }
    }

    var errorMessage: String? {
        get { errorLabel.text }
        set { errorLabel.text = newValue }
    }

    private var separatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        return view
    }()

    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = .zero
        return stackView
    }()

    private var textField = CustomTextField()

    private var errorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.textColor = .systemRed
        return label
    }()

    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        layout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        layout()
    }
    
    // MARK: - Private methods
    private func commonInit() {
        textField.delegate = self
        textField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture)))
        backgroundColor = .secondarySystemBackground
        isUserInteractionEnabled = true
    }

    private func layout() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textField)
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 13)
        ])

        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: textField.bottomAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
        stackView.addArrangedSubview(errorLabel)

        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        separatorLineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        stackView.addArrangedSubview(separatorLineView)
    }

    private func updateValidity() {
        separatorLineView.backgroundColor = isValid ? .separator: .systemRed
    }

    @objc private func handleTextChange() {
        delegate?.inputViewTextDidChange(self)
    }

    @objc private func handleTapGesture() {
        if !textField.isFirstResponder {
            textField.becomeFirstResponder()
        }
    }
}

// MARK: - UITextFieldDelegate
extension CustomInputView: UITextFieldDelegate {

}
