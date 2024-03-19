//
//  LoginViewController.swift
//  GIL
//
//  Created by 송우진 on 3/18/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let emailTextField = BasicTextField(type: .email)
    private let passwordTextField = BasicTextField(type: .password)
    private let loginButton = BasicButton(title: "로그인")
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 3
        return stack
    }()
    private let signUpLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 회원이 아니신가요?"
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        makeConstraints()
    }
}

// MARK: - Action
extension LoginViewController {
    @objc func login() {
        /// 로그인
    }
    
    @objc func signUp() {
        /// 회원가입
    }
}

// MARK: - Configure UI
extension LoginViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        [emailTextField, passwordTextField, loginButton, stackView].forEach({
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        [signUpLabel, signUpButton].forEach({    
            stackView.addArrangedSubview($0)
        })
        
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        
    }
    
    func makeConstraints() {
        emailTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 120).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor).isActive = true
        
        loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        stackView.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 40).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

}
