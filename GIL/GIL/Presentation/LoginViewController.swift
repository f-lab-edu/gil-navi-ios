//
//  LoginViewController.swift
//  GIL
//
//  Created by 송우진 on 3/18/24.
//

import UIKit
import Combine

final class LoginViewController: BaseViewController {
    private var cancellables: Set<AnyCancellable> = []
    private var viewModel: LoginViewModel
    private var loginView = LoginView()

    // MARK: - Initialization
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
}

// MARK: - Setup Binding
extension LoginViewController {
    private func setupBindings() {
        setupBindTextFields()
        setupBindButtons()
        bindErrors()
    }
    
    private func setupBindTextFields() {
        loginView.emailTextField.delegate = self
        loginView.passwordTextField.delegate = self
    }
    
    private func setupBindButtons() {
        loginView.loginButton.addAction(UIAction { [weak self] _ in self?.loginButtonTapped()}, for: .touchUpInside)
        loginView.signUpButton.addAction(UIAction { [weak self] _ in self?.signUpButtonTapped()}, for: .touchUpInside)
        loginView.appleLoginButton.addAction(UIAction { [weak self] _ in self?.appleLoginButtonTapped()}, for: .touchUpInside)
    }
    
    private func bindErrors() {
        viewModel.errors
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.handleError(error)
            }
            .store(in: &cancellables)
    }
    
}

// MARK: - Error
extension LoginViewController {
    private func handleError(_ error: Error) {
        #if DEV
        switch error {
        case let authenticationError as AuthenticationError: Log.error("AuthenticationError", authenticationError.errorDescription)
        case let cryptoUtilsError as CryptoUtilsError: Log.error("CryptoUtilsError", cryptoUtilsError.localizedDescription)
        default: Log.error("Unknown Login Error", error.localizedDescription)
        }
        #endif
        LoadingView.hide()
        AlertService.showAlert(title: "로그인 실패", message: "로그인을 다시 시도해주세요.")
    }
}

// MARK: - Actions
extension LoginViewController {
    func loginButtonTapped() {
        guard let email = loginView.emailTextField.text, !email.isEmpty,
              let password = loginView.passwordTextField.text, !password.isEmpty
        else {
            focusFirstEmptyField()
            return
        }
        LoadingView.show()
        viewModel.signInWithEmail(email: email, password: password)
    }

    private func focusFirstEmptyField() {
        if loginView.emailTextField.text?.isEmpty ?? true {
            loginView.emailTextField.becomeFirstResponder()
        } else {
            loginView.passwordTextField.becomeFirstResponder()
        }
    }
    
    func signUpButtonTapped() {
        viewModel.showSignUp()
    }
    
    func appleLoginButtonTapped() {
        LoadingView.show()
        viewModel.prepareAppleSignIn()
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case loginView.emailTextField: loginView.passwordTextField.becomeFirstResponder()
        case loginView.passwordTextField: loginButtonTapped()
        default: break
        }
        return true
    }
}
