//
//  MainViewModel.swift
//  TestTask
//
//  Created by Oleh Mykytyn on 17.12.2022.
//

import Foundation

private enum Constants {
    static let minimumAllowedBound = 1
    static let maximumAllowedBound = 500
}

private enum ErrorMessage {
    static let inputTextShouldNotBeEmpty = "Text input should not be empty"
    static let inputValueShouldBeNumber = "Input value should be numeric"
    static let defaultErrorMessage = "Input value is not valid"
    static let boundsShouldBeInRange = "Bounds shound be in range 1...500"
    static let lowerBoundShouldBeSmallerThenHigher = "Lower bound should be smaller then higher bound"
    static let upperBoundShouldBeBiggerThenLower = "Upper bound should be bigger then lower bound"
}

protocol MainViewModelProtocol {
    func validateUpperBoundText(_ text: String?, lowerBoundText: String?)
    func validateLowerBoundText(_ text: String?, upperBoundText: String?)
}

final class MainViewModel: MainViewModelProtocol {
    // MARK: - Properties
    private weak var viewController: MainViewControllerProtocol!

    // MARK: - Life cycle
    init(viewController: MainViewControllerProtocol) {
        self.viewController = viewController
    }

    // MARK: - MainViewModelProtocol
    func validateLowerBoundText(_ text: String?, upperBoundText: String?) {
        let result = performCommonValidation(text)

        if let lowerBound = text, let upperBound = upperBoundText,
           let lowerBoundInt = Int(lowerBound), let upperBoundInt = Int(upperBound),
           lowerBoundInt > upperBoundInt {
            viewController.updateLowerBoundInputViewValidity(
                isValid: false,
                errorMessage: ErrorMessage.lowerBoundShouldBeSmallerThenHigher
            )
            return
        }

        viewController.updateLowerBoundInputViewValidity(
            isValid: result.isValid,
            errorMessage: result.errorMessage
        )
    }
    
    func validateUpperBoundText(_ text: String?, lowerBoundText: String?) {
        let result = performCommonValidation(text)
        if let upperBound = text, let lowerBound = lowerBoundText,
           let upperBoundInt = Int(upperBound), let lowerBoundInt = Int(lowerBound),
            upperBoundInt < lowerBoundInt {
            viewController.updateUpperBoundInputViewValidity(
                isValid: false,
                errorMessage: ErrorMessage.upperBoundShouldBeBiggerThenLower
            )
            return
        }

        viewController.updateUpperBoundInputViewValidity(
            isValid: result.isValid,
            errorMessage: result.errorMessage
        )
    }

    // MARK: - Private methods
    private func performCommonValidation(_ text: String?) -> (isValid: Bool, errorMessage: String?) {
        guard let text = text, !text.isEmpty else {
            return (isValid: false, errorMessage: ErrorMessage.inputTextShouldNotBeEmpty)
        }

        guard let integer = Int(text) else {
            return (isValid: false, errorMessage: ErrorMessage.inputValueShouldBeNumber)
        }

        guard integer >= Constants.minimumAllowedBound && integer <= Constants.maximumAllowedBound else {
            return (isValid: false, errorMessage: ErrorMessage.boundsShouldBeInRange)
        }

        return (isValid: true, errorMessage: nil)
    }
}
