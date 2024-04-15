//
//  SignUpView.swift
//  GIL
//
//  Created by 송우진 on 3/26/24.
//

import UIKit

final class SignUpView: UIView {
    let closeButton = CloseButton()
    let emailTextField = BasicTextField(type: .email, returnKeyType: .next, clearButtonMode: .whileEditing)
    let nameTextField = BasicTextField(type: .unknown(placeholder: "Name"), returnKeyType: .next, clearButtonMode: .whileEditing)
    let passwordTextField = BasicTextField(type: .password, returnKeyType: .next)
    let confirmPasswordTextField = BasicTextField(type: .password, returnKeyType: .done)
    let confirmButton = BasicButton(title: "완료")
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Drawing Cycle
    override func updateConstraints() {
        super.updateConstraints()
        makeConstraints()
    }

}

// MARK: - Configure UI
extension SignUpView {
    func configureUI() {
        backgroundColor = .systemBackground
        
        [closeButton, emailTextField, nameTextField, passwordTextField, confirmPasswordTextField, confirmButton].forEach({
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
    }
    
    func makeConstraints() {
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: StatusBarManager.shared.statusBarHeight + 10),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            closeButton.heightAnchor.constraint(equalToConstant: 44),
            emailTextField.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 40),
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            emailTextField.heightAnchor.constraint(equalToConstant: 60),
            nameTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
            nameTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            nameTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
            passwordTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10),
            passwordTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: nameTextField.heightAnchor),
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            confirmPasswordTextField.heightAnchor.constraint(equalTo: passwordTextField.heightAnchor),
            confirmButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 30),
            confirmButton.leadingAnchor.constraint(equalTo: confirmPasswordTextField.leadingAnchor),
            confirmButton.trailingAnchor.constraint(equalTo: confirmPasswordTextField.trailingAnchor),
            confirmButton.heightAnchor.constraint(equalTo: confirmPasswordTextField.heightAnchor)
        ])
    }
}
