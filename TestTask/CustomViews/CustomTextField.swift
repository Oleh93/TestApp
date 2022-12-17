//
//  CustomTextField.swift
//  TestTask
//
//  Created by Oleh Mykytyn on 17.12.2022.
//

import Foundation
import UIKit

final class CustomTextField: UITextField {
    // MARK: - Properties
    private let textPadding: UIEdgeInsets = .init(top: .zero, left: 16, bottom: .zero, right: 16)

    // MARK: Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    // MARK: - Private
    private func setupUI() {
        font = .systemFont(ofSize: 17, weight: .regular)
        backgroundColor = .secondarySystemBackground
        tintColor = .tintColor
    }
}
