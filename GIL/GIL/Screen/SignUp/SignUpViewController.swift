//
//  SignUpViewController.swift
//  GIL
//
//  Created by 송우진 on 3/26/24.
//

import UIKit
import Combine

final class SignUpViewController: UIViewController {
    private var viewModel: SignUpViewModel
    var signUpView = SignUpView()
    
    // MARK: - Initialization
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func loadView() {
        view = signUpView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
}

// MARK: - Binding
extension SignUpViewController {
    func setupBindings() {
        bindButtons()
        bindTextFields()
        bindPublishers()
    }
    
    private func bindButtons() {
        let closeAction = UIAction { _ in self.closeButtonTapped() }
        signUpView.closeButton.addAction(closeAction, for: .touchUpInside)
        
        let doneAction = UIAction { _ in self.doneButtonTapped() }
        signUpView.doneButton.addAction(doneAction, for: .touchUpInside)
    }
    
    private func bindTextFields() {
        signUpView.emailTextField.delegate = self
        signUpView.nameTextField.delegate = self
        signUpView.passwordTextField.delegate = self
        signUpView.confirmPasswordTextField.delegate = self
    }
    
    private func bindPublishers() {
        viewModel.emailPublisher
            .dropFirst()
            .sink { [weak self] email in
                guard let self else { return }
                self.signUpView.emailTextField.layer.borderColor = email.isValidEmail() ? BasicTextField.validBorderColor : BasicTextField.invalidBorderColor
            }
            .store(in: &viewModel.cancellables)
        
        viewModel.namePublisher
            .dropFirst()
            .sink(receiveValue: { [weak self] name in
                guard let self else { return }
                self.signUpView.nameTextField.layer.borderColor = !name.isEmpty ? BasicTextField.validBorderColor : BasicTextField.invalidBorderColor
            })
            .store(in: &viewModel.cancellables)
        
        viewModel.passwordPublisher
            .dropFirst()
            .sink(receiveValue: { [weak self] password in
                guard let self else { return }
                self.signUpView.passwordTextField.layer.borderColor = password.isValidPassword() ? BasicTextField.validBorderColor : BasicTextField.invalidBorderColor
            })
            .store(in: &viewModel.cancellables)
        
        viewModel.confirmPasswordPublisher
            .dropFirst()
            .sink(receiveValue: { [weak self] password in
                guard let self else { return }
                self.signUpView.confirmPasswordTextField.layer.borderColor = (password == viewModel.passwordPublisher.value) ? BasicTextField.validBorderColor : BasicTextField.invalidBorderColor
            })
            .store(in: &viewModel.cancellables)
        
        viewModel.isFormValidPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                guard let self else { return }
                self.signUpView.doneButton.isEnabled = isValid
                self.signUpView.doneButton.backgroundColor = isValid ? BasicButton.enabledBackgroundColor : BasicButton.disabledBackgroundColor
            }
            .store(in: &viewModel.cancellables)

    }
}

// MARK: - Action
extension SignUpViewController {
    func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    func doneButtonTapped() {
        dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case signUpView.emailTextField:
            showLabel(signUpView.emailLabel, constraint: signUpView.emailLabelHeightConstraint)
            
        case signUpView.nameTextField:
            showLabel(signUpView.nameLabel, constraint: signUpView.nameLabelHeightConstraint)
            
        case signUpView.passwordTextField:
            showLabel(signUpView.passwordLabel, constraint: signUpView.passwordLabelHeightConstraint)
            
        case signUpView.confirmPasswordTextField:
            showLabel(signUpView.confirmPasswordLabel, constraint: signUpView.confirmPasswordLabelHeightConstraint)
            
        default: break
        }
        
        view.layoutIfNeeded()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case signUpView.emailTextField:
            hideLabel(signUpView.emailLabel, constraint: signUpView.emailLabelHeightConstraint)
            
        case signUpView.nameTextField:
            hideLabel(signUpView.nameLabel, constraint: signUpView.nameLabelHeightConstraint)
            
        case signUpView.passwordTextField:
            hideLabel(signUpView.passwordLabel, constraint: signUpView.passwordLabelHeightConstraint)
            
        case signUpView.confirmPasswordTextField:
            hideLabel(signUpView.confirmPasswordLabel, constraint: signUpView.confirmPasswordLabelHeightConstraint)
            
        default: break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case signUpView.emailTextField:
            signUpView.nameTextField.becomeFirstResponder()
            
        case signUpView.nameTextField:
            signUpView.passwordTextField.becomeFirstResponder()
            
        case signUpView.passwordTextField:
            signUpView.confirmPasswordTextField.becomeFirstResponder()
            
        case signUpView.confirmPasswordTextField:
            view.endEditing(true)
            
        default: break
        }
        return true
    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard string != " " else { return false }
        guard let currentText = textField.text else { return true }
        
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)

        switch textField {
        case signUpView.emailTextField:
            viewModel.emailPublisher.send(newText)
            
        case signUpView.nameTextField:
            viewModel.namePublisher.send(newText)
            
        case signUpView.passwordTextField,
            signUpView.confirmPasswordTextField:
            
            if string.isEmpty { // 백스페이스 허용
                updatePasswordPublisher(textField: textField, text: newText)
                return true
            }
            
            let isValid = viewModel.validateAlphaNumericString(inputString: string)
            if isValid {
                updatePasswordPublisher(textField: textField, text: newText)
            }
 
            return isValid
        
        default: break
        }
        
        return true
    }
    
    private func updatePasswordPublisher(
        textField: UITextField,
        text: String
    ) {
        if textField == signUpView.passwordTextField {
            viewModel.passwordPublisher.send(text)
        } else if textField == signUpView.confirmPasswordTextField {
            viewModel.confirmPasswordPublisher.send(text)
        }
    }
    
    
    private func showLabel(_ label: UILabel, constraint: NSLayoutConstraint) {
        UIView.animate(withDuration: 0.3) {
            label.alpha = 1.0
            constraint.constant = 16
            self.view.layoutIfNeeded()
        }
    }

    private func hideLabel(_ label: UILabel, constraint: NSLayoutConstraint) {
        UIView.animate(withDuration: 0.3) {
            label.alpha = 0
            constraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}
