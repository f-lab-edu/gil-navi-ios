//
//  SignUpTextFieldHandler.swift
//  GIL
//
//  Created by 송우진 on 5/4/24.
//

import UIKit

final class SignUpTextFieldHandler: NSObject, UITextFieldDelegate {
    private var viewModel: SignUpViewModel?
    private weak var signUpView: SignUpView?
    
    // MARK: - Initialization
    init(
        viewModel: SignUpViewModel,
        view: SignUpView
    ) {
        self.viewModel = viewModel
        self.signUpView = view
        super.init()
        setupBindTextFields()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Binding
    private func setupBindTextFields() {
        guard let signUpView = signUpView else { return }
        signUpView.emailTextField.delegate = self
        signUpView.nameTextField.delegate = self
        signUpView.passwordTextField.delegate = self
        signUpView.verifyPasswordTextField.delegate = self
    }
}

// MARK: - UITextFieldDelegate
extension SignUpTextFieldHandler {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateLabelVisibility(for: textField, shouldShow: true)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        updateLabelVisibility(for: textField, shouldShow: false)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        moveToNextTextField(textField)
        return true
    }

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let signUpView = signUpView,
              let viewModel = viewModel,
              let currentText = textField.text,
              string != " "
        else { return false }
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        updateViewModel(for: textField, with: newText)
        return true
    }
}

// MARK: - Update
extension SignUpTextFieldHandler {
    private func updateLabelVisibility(
        for textField: UITextField,
        shouldShow: Bool
    ) {
        guard let signUpView = signUpView else { return }
        switch textField {
        case signUpView.emailTextField: signUpView.animateLabelVisibility(signUpView.emailLabel, shouldShow: shouldShow)
        case signUpView.nameTextField: signUpView.animateLabelVisibility(signUpView.nameLabel, shouldShow: shouldShow)
        case signUpView.passwordTextField: signUpView.animateLabelVisibility(signUpView.passwordLabel, shouldShow: shouldShow)
        case signUpView.verifyPasswordTextField: signUpView.animateLabelVisibility(signUpView.verifyPasswordLabel, shouldShow: shouldShow)
        default: break
        }
    }

    private func moveToNextTextField(_ textField: UITextField) {
        guard let signUpView = signUpView else { return }
        switch textField {
        case signUpView.emailTextField: signUpView.nameTextField.becomeFirstResponder()
        case signUpView.nameTextField: signUpView.passwordTextField.becomeFirstResponder()
        case signUpView.passwordTextField: signUpView.verifyPasswordTextField.becomeFirstResponder()
        case signUpView.verifyPasswordTextField: signUpView.endEditing(true)
        default: break
        }
    }
    
    private func updateViewModel(
        for textField: UITextField,
        with newText: String
    ) {
        guard let signUpView = signUpView,
              let viewModel = viewModel
        else { return }
        switch textField {
        case signUpView.emailTextField: viewModel.emailPublisher.send(newText)
        case signUpView.nameTextField: viewModel.namePublisher.send(newText)
        case signUpView.passwordTextField: viewModel.passwordPublisher.send(newText)
        case signUpView.verifyPasswordTextField: viewModel.verifyPasswordPublisher.send(newText)
        default: break
        }
    }
}
