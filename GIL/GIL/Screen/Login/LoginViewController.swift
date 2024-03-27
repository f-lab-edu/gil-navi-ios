//
//  LoginViewController.swift
//  GIL
//
//  Created by 송우진 on 3/18/24.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    private var viewModel = LoginViewModel()
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
        bindPublishers()
    }
    
    private func bindTextFields() {
        loginView.emailTextField.delegate = self
        loginView.passwordTextField.delegate = self
    }
    
    private func bindButtons() {
        loginView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        loginView.signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        loginView.appleLoginButton.addTarget(self, action: #selector(appleLoginButtonTapped), for: .touchUpInside)
    }
    
    private func bindPublishers() {
        viewModel.loginPublisher
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    print("Finished")
                case .failure(let failure):
                    print("Failure : \(failure.localizedDescription)")
                }
            }, receiveValue: { [weak self] _ in
                print("로그인 성공 ")
            })
            .store(in: &viewModel.cancellables)
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
    
    @objc func appleLoginButtonTapped() {
        // 애플 로그인
        viewModel.didTappedLoginButton()
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
