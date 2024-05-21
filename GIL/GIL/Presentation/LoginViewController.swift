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
        subscribeToPublishers()
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
    
    private func subscribeToPublishers() {
        viewModel.loginPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loginResult in
                guard let self else { return }
                switch loginResult {
                case .success(_): viewModel.signInAnonymously()
                case .failure(let errorMessage): AlertService.showAlert(title: "로그인 실패", message: errorMessage)
                case .none: break
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Actions
extension LoginViewController {
    func loginButtonTapped() {
        guard let email = loginView.emailTextField.text,
              !email.isEmpty
        else {
            loginView.emailTextField.becomeFirstResponder()
            return
        }
        
        guard let password = loginView.passwordTextField.text,
              !password.isEmpty
        else {
            loginView.passwordTextField.becomeFirstResponder()
            return
        }
        
        viewModel.signInWithEmail(email: email, password: password)
    }
    
    func signUpButtonTapped() {
        viewModel.showSignUp()
    }
    
    func appleLoginButtonTapped() {
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
