//
//  LoginView.swift
//  GIL
//
//  Created by 송우진 on 3/21/24.
//

import UIKit
import AuthenticationServices

final class LoginView: UIView {
    private let formStackView = BaseStackView(axis: .vertical, spacing: 10)
    private let singUpStackView = BaseStackView(axis: .horizontal, distribution: .fill, spacing: 3)
    let emailTextField = BasicTextField(type: .email, returnKeyType: .next)
    let passwordTextField = BasicTextField(type: .password, returnKeyType: .done)
    let loginButton = InteractiveButton(title: "로그인", titleColor: .white, fontSize: 18, fontWeight: .bold)
    let signUpButton = BaseButton(title: "회원가입", titleColor: .red, fontWeight: .semibold)
    let appleLoginButton = BaseButton(bgNormal: UIImage(named: "logo-apple"), bgHighlighted: UIImage(named: "logo-apple"))
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Drawing Cycle
    override func updateConstraints() {
        setConstraints()
        super.updateConstraints()

    }
}

// MARK: - Configure UI
extension LoginView {
    func configureUI() {
        [emailTextField, passwordTextField, loginButton, stackView, border, socialLabel, appleLoginButton].forEach({
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        [signUpLabel, signUpButton].forEach({
            stackView.addArrangedSubview($0)
        })
        
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: topAnchor, constant: 120),
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            emailTextField.heightAnchor.constraint(equalToConstant: 55),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            loginButton.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 60),
            stackView.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 40),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            border.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -120),
            border.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            border.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            border.heightAnchor.constraint(equalToConstant: 1),
            socialLabel.centerXAnchor.constraint(equalTo: border.centerXAnchor),
            socialLabel.centerYAnchor.constraint(equalTo: border.centerYAnchor),
            appleLoginButton.topAnchor.constraint(equalTo: border.bottomAnchor, constant: 20),
            appleLoginButton.centerXAnchor.constraint(equalTo: border.centerXAnchor),
            appleLoginButton.widthAnchor.constraint(equalToConstant: 50),
            appleLoginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
