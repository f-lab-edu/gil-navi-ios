//
//  LoginView.swift
//  GIL
//
//  Created by 송우진 on 3/21/24.
//

import UIKit

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
        [emailTextField, passwordTextField, loginButton, stackView].forEach({
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
        
        loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        stackView.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 40).isActive = true
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
