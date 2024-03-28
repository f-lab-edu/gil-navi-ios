//
//  LoginViewController.swift
//  GIL
//
//  Created by 송우진 on 3/18/24.
//

import UIKit

final class LoginViewController: UIViewController {
    
    private var loginView = LoginView()

    // MARK: - Life Cycle
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
    }
}

// MARK: - Binding
extension LoginViewController {
    func setupBindings() {
        bindTextFields()
        bindButtons()
    }
    
    private func bindTextFields() {
        loginView.emailTextField.delegate = self
        loginView.passwordTextField.delegate = self
    }
    
    private func bindButtons() {
        loginView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        loginView.signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
}

// MARK: - Actions
extension LoginViewController {
    @objc func loginButtonTapped() {
        // 로그인
        view.endEditing(true)
    }
    
    @objc func signUpButtonTapped() {
        // 회원가입
        
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case loginView.emailTextField:
            loginView.passwordTextField.becomeFirstResponder()
            
        case loginView.passwordTextField:
            loginButtonTapped()
            
        default: break
        }
        return true
    }

}
