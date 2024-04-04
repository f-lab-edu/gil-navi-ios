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
     
        let appleLoginAction = UIAction { _ in self.viewModel.startSignInWithAppleFlow() }
        loginView.appleLoginButton.addAction(appleLoginAction, for: .touchUpInside)
    }
    
    private func bindPublishers() {
        viewModel.loginPublisher
            .sink { [weak self] result in
                guard let `self` = self else { return }
                switch result {
                case .finished:
                    self.navigateToHomeAndRemoveLoginScreen()
                    
                case .failure(let failure):
                    Log.error("Failure : \(failure.localizedDescription)")
                    
                }
            } receiveValue: { _ in }
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
    
    func navigateToHomeAndRemoveLoginScreen() {
        let homeViewController = HomeViewController(viewModel: HomeViewModel())
        if let navigationController = self.navigationController {
            var viewControllers = navigationController.viewControllers
            viewControllers.removeLast()  // 로그인 화면 제거
            viewControllers.append(homeViewController)  // 홈 화면 추가
            navigationController.setViewControllers(viewControllers, animated: true)
        }
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
