//
//  LoginViewController.swift
//  GIL
//
//  Created by 송우진 on 3/18/24.
//

import UIKit
import Combine

final class LoginViewController: UIViewController {
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
        bindTextFields()
        bindButtons()
        bindPublishers()
    }
    
    private func bindTextFields() {
        loginView.emailTextField.delegate = self
        loginView.passwordTextField.delegate = self
    }
    
    private func bindButtons() {
        let loginAction = UIAction { _ in self.loginButtonTapped() }
        loginView.loginButton.addAction(loginAction, for: .touchUpInside)
        
        let signUpAction = UIAction { _ in self.signUpButtonTapped() }
        loginView.signUpButton.addAction(signUpAction, for: .touchUpInside)
     
        let appleLoginAction = UIAction { _ in self.appleLoginButtonTapped() }
        loginView.appleLoginButton.addAction(appleLoginAction, for: .touchUpInside)
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
    func loginButtonTapped() {
        // 로그인
        view.endEditing(true)
    }
    
    func signUpButtonTapped() {
        // 회원가입
    }
    
    func appleLoginButtonTapped() {
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
