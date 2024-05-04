//
//  LoginViewController.swift
//  GIL
//
//  Created by 송우진 on 3/18/24.
//

import UIKit
import Combine
import FirebaseAuth

final class LoginViewController: BaseViewController {
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

// MARK: - Binding
extension LoginViewController {
    func setupBindings() {
        setupBindTextFields()
        setupBindButtons()
        subscribeToPublishers()
    }
    
    private func setupBindTextFields() {
        loginView.emailTextField.delegate = self
        loginView.passwordTextField.delegate = self
    }
    
    private func setupBindButtons() {
        loginView.loginButton.addAction(UIAction { _ in self.loginButtonTapped()}, for: .touchUpInside)
        loginView.signUpButton.addAction(UIAction { _ in self.signUpButtonTapped()}, for: .touchUpInside)
        loginView.appleLoginButton.addAction(UIAction { _ in self.viewModel.startSignInWithAppleFlow()}, for: .touchUpInside)
    }
    
    private func subscribeToPublishers() {
        viewModel.loginPublisher
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case .finished: FirebaseAuthManager.signInAnonymously()
                case .failure(let error):
                    let errorMessage = viewModel.errorMessage(for: error)
                    AlertService.showAlert(title: "로그인 실패", message: errorMessage, on: self)
                }
            } receiveValue: { _ in }
            .store(in: &viewModel.cancellables)
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
        let signUpViewController = SignUpViewController(viewModel: SignUpViewModel())
        signUpViewController.modalPresentationStyle = .fullScreen
        present(signUpViewController, animated: true)
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
