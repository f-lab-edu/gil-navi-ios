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
        bindValidationUpdates()
        bindFormCompletion()
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
        signUpView.verifyPasswordTextField.delegate = self
    }
    
    private func bindFormCompletion() {
        viewModel.createUserPublisher
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .finished:
                    Log.network("회원가입 성공")
                    
                case .failure(let error):
                    // TODO: AlertService 적용 필요
                    if let signUpError = error as? SignUpViewModel.SignUpError,
                       let errorDesc = signUpError.errorDescription
                    {
                        Log.error("회원 정보 부족 : \(errorDesc)")
                        
                    } else if let authError = error as? FirebaseAuthError,
                              let errorDesc = authError.errorDescription
                    {
                        Log.error("회원가입 실패 : \(errorDesc)")
                    }
                }
            } receiveValue: { _ in }
            .store(in: &viewModel.cancellables)
    }
    
    private func bindValidationUpdates() {
        bindEmailValidation()
        bindNameValidation()
        bindPasswordValidation()
        bindFormValidation()
    }
    
    private func bindEmailValidation() {
        viewModel.emailPublisher
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] email in
                guard let self else { return }
                self.updateTextFieldBorderColor(textField: self.signUpView.emailTextField, isValid: email.isValidEmail())
            }
            .store(in: &viewModel.cancellables)
    }
    
    private func bindNameValidation() {
        viewModel.namePublisher
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] name in
                guard let self else { return }
                self.updateTextFieldBorderColor(textField: self.signUpView.nameTextField, isValid: !name.isEmpty)
            }
            .store(in: &viewModel.cancellables)
    }
    
    private func bindPasswordValidation() {
        viewModel.passwordPublisher
            .dropFirst()
            .map { password -> (validations: [Bool], isValid: Bool) in
                let validations = password.validatePassword()
                let isValid = validations.allSatisfy { $0 }
                return (validations, isValid)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                self.updateTextFieldBorderColor(textField: self.signUpView.passwordTextField, isValid: result.isValid)
                
                /// 비밀번호 유효성 레이블 업데이트
                self.updatePasswordValidationLabels(validations: result.validations)
            }
            .store(in: &viewModel.cancellables)

        viewModel.passwordMatchPublisher
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isMatch in
                guard let self else { return }
                self.updateTextFieldBorderColor(textField: self.signUpView.verifyPasswordTextField, isValid: isMatch)
            }
            .store(in: &viewModel.cancellables)
    }

    private func bindFormValidation() {
        viewModel.isFormValidPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                guard let self else { return }
                self.signUpView.doneButton.backgroundColor = isValid ? BasicButton.enabledBackgroundColor : BasicButton.disabledBackgroundColor
            }
            .store(in: &viewModel.cancellables)
    }
    
}

// MARK: - Actions
extension SignUpViewController {
    func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    func doneButtonTapped() {
        Task {
            await viewModel.createUser()
        }
    }
}

// MARK: - UI Updates
extension SignUpViewController {
    private func updateTextFieldBorderColor(textField: UITextField, isValid: Bool) {
        let color = isValid ? BasicTextField.validBorderColor : BasicTextField.invalidBorderColor
        textField.layer.borderColor = color
    }
    
    private func updatePasswordValidationLabels(validations: [Bool]) {
        let labels = [
            signUpView.checkPasswordLabel_01,
            signUpView.checkPasswordLabel_02,
            signUpView.checkPasswordLabel_03,
            signUpView.checkPasswordLabel_04
        ]

        for (index, label) in labels.enumerated() {
            let isValid = index < validations.count ? validations[index] : false
            label.textColor = isValid ? .mainGreen : .text
        }
    }
    
    private func animateLabelVisibility(_ label: UILabel,
                                        shouldShow: Bool,
                                        constraint: NSLayoutConstraint
    ) {
        UIView.animate(withDuration: 0.3) {
            label.alpha = shouldShow ? 1.0 : 0
            constraint.constant = shouldShow ? 16 : 0
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case signUpView.emailTextField:
            animateLabelVisibility(signUpView.emailLabel, shouldShow: true, constraint: signUpView.emailLabelHeightConstraint)
            
        case signUpView.nameTextField:
            animateLabelVisibility(signUpView.nameLabel, shouldShow: true, constraint: signUpView.nameLabelHeightConstraint)
            
        case signUpView.passwordTextField:
            animateLabelVisibility(signUpView.passwordLabel, shouldShow: true, constraint: signUpView.passwordLabelHeightConstraint)
            
        case signUpView.verifyPasswordTextField:
            animateLabelVisibility(signUpView.verifyPasswordLabel, shouldShow: true, constraint: signUpView.verifyPasswordLabelHeightConstraint)
            
        default: break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case signUpView.emailTextField:
            animateLabelVisibility(signUpView.emailLabel, shouldShow: false, constraint: signUpView.emailLabelHeightConstraint)
            
        case signUpView.nameTextField:
            animateLabelVisibility(signUpView.nameLabel, shouldShow: false, constraint: signUpView.nameLabelHeightConstraint)
            
        case signUpView.passwordTextField:
            animateLabelVisibility(signUpView.passwordLabel, shouldShow: false, constraint: signUpView.passwordLabelHeightConstraint)
            
        case signUpView.verifyPasswordTextField:
            animateLabelVisibility(signUpView.verifyPasswordLabel, shouldShow: false, constraint: signUpView.verifyPasswordLabelHeightConstraint)
            
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
            signUpView.verifyPasswordTextField.becomeFirstResponder()
            
        case signUpView.verifyPasswordTextField:
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
            signUpView.verifyPasswordTextField:
            updatePasswordPublisher(textField: textField, text: newText)
        
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
        } else if textField == signUpView.verifyPasswordTextField {
            viewModel.verifyPasswordPublisher.send(text)
        }
    }
}
