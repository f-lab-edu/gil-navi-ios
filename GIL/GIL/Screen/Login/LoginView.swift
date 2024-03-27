//
//  LoginView.swift
//  GIL
//
//  Created by 송우진 on 3/21/24.
//

import UIKit
import AuthenticationServices

final class LoginView: UIView {
    let emailTextField = BasicTextField(type: .email, returnType: .next)
    let passwordTextField = BasicTextField(type: .password, returnType: .done)
    let loginButton = BasicButton(title: "로그인")
    let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        return button
    }()
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
    let socialLabel: UILabel = {
        let label = UILabel()
        label.text = "SNS 계정으로 로그인"
        label.backgroundColor = .white
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    let appleLoginButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "logo-apple-white"), for: .normal)
        button.setImage(UIImage(named: "logo-apple-white"), for: .highlighted)
        button.clipsToBounds = true
        button.layer.cornerRadius = 55/2
        button.backgroundColor = .black
        return button
    }()
    let border: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(hex: "#DADADA")
        return label
    }()
    
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    
    func makeConstraints() {
        emailTextField.topAnchor.constraint(equalTo: topAnchor, constant: 120).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor).isActive = true
        
        loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        stackView.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 40).isActive = true
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        border.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -120).isActive = true
        border.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
        border.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30).isActive = true
        border.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        socialLabel.centerXAnchor.constraint(equalTo: border.centerXAnchor).isActive = true
        socialLabel.centerYAnchor.constraint(equalTo: border.centerYAnchor).isActive = true
        
        appleLoginButton.topAnchor.constraint(equalTo: border.bottomAnchor, constant: 20).isActive = true
        appleLoginButton.centerXAnchor.constraint(equalTo: border.centerXAnchor).isActive = true
        appleLoginButton.widthAnchor.constraint(equalToConstant: 55).isActive = true
        appleLoginButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
    }
}
