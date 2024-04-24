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
                guard let self else { return }
                switch result {
                case .finished:
                    Auth.auth().signInAnonymously()
                case .failure(let error):
                    Log.error("로그인 실패", error)
                    var errorMessage = "로그인 중 예상치 못한 오류가 발생했습니다. 잠시 후 다시 시도해 주세요."
                    
                    if let loginError = error as? LoginViewModel.LoginError,
                       let errorDesc = loginError.errorDescription {
                        errorMessage = errorDesc
                    }
                    self.showAlert(title: "로그인 실패", message: errorMessage)
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
        let signUpViewController = SignUpViewController(viewModel: SignUpViewModel())
        signUpViewController.modalPresentationStyle = .fullScreen
        present(signUpViewController, animated: true)
    }
}

// MARK: - UI Handling
extension LoginViewController {
    func showAlert(title: String,
                   message: String = ""
    ) {
        viewModel.alertService.showAlert(title: title, message: message, on: self)
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
