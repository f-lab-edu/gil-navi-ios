//
//  SignUpViewController.swift
//  GIL
//
//  Created by 송우진 on 3/26/24.
//

import UIKit

class SignUpViewController: UIViewController {
    private var viewModel: SignUpViewModel
    private var signUpView = SignUpView()
    
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
        
        let confirmAction = UIAction { _ in self.confirmButtonTapped() }
        signUpView.confirmButton.addAction(confirmAction, for: .touchUpInside)
    }
    
    private func bindTextFields() {
        signUpView.emailTextField.delegate = self
        signUpView.nameTextField.delegate = self
        signUpView.passwordTextField.delegate = self
        signUpView.confirmPasswordTextField.delegate = self
    }
    
    private func bindPublishers() {
        viewModel.emailPublisher
            .sink(receiveCompletion: { _ in},
                  receiveValue: { [weak self] email in
                guard let `self` = self else { return }
                if email.isValidEmail() {
                    self.signUpView.emailTextField.layer.borderColor = BasicTextField.validBorderColor
                } else {
                    self.signUpView.emailTextField.layer.borderColor = BasicTextField.invalidBorderColor
                }
            })
            .store(in: &viewModel.cancellables)
        
    }
}

// MARK: - Action
extension SignUpViewController {
    func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    func confirmButtonTapped() {
        dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return true }
        
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)

        switch textField {
        case signUpView.emailTextField:
            viewModel.emailPublisher.send(newText)
        
        default: break
        }
        return true
    }
}
