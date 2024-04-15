//
//  SignUpView.swift
//  GIL
//
//  Created by 송우진 on 3/26/24.
//

import UIKit

final class SignUpView: UIView {
    let closeButton = CloseButton()
    let emailLabel = UILabel()
    let emailTextField = BasicTextField(type: .email, returnKeyType: .next, clearButtonMode: .whileEditing)
    let nameLabel = UILabel()
    let nameTextField = BasicTextField(type: .unknown(placeholder: "Name"), returnKeyType: .next, clearButtonMode: .whileEditing)
    let passwordLabel = UILabel()
    let passwordTextField = BasicTextField(type: .password, returnKeyType: .next)
    let confirmPasswordLabel = UILabel()
    let confirmPasswordTextField = BasicTextField(type: .password, returnKeyType: .done)
    let doneButton = BasicButton(title: "완료")
    
    var emailLabelHeightConstraint: NSLayoutConstraint = .init()
    var nameLabelHeightConstraint: NSLayoutConstraint = .init()
    var passwordLabelHeightConstraint: NSLayoutConstraint = .init()
    var confirmPasswordLabelHeightConstraint: NSLayoutConstraint = .init()
    
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
        
        configureLabel(emailLabel, text: "이메일")
        configureLabel(nameLabel, text: "이름")
        configureLabel(passwordLabel, text: "비밀번호")
        configureLabel(confirmPasswordLabel, text: "비밀번호 재확인")
        
        [closeButton, emailLabel, emailTextField, nameLabel, nameTextField, passwordLabel, passwordTextField, confirmPasswordLabel, confirmPasswordTextField, doneButton].forEach ({
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
    }
    
    func makeConstraints() {
        emailLabelHeightConstraint = emailLabel.heightAnchor.constraint(equalToConstant: 0)
        nameLabelHeightConstraint = nameLabel.heightAnchor.constraint(equalToConstant: 0)
        passwordLabelHeightConstraint = passwordLabel.heightAnchor.constraint(equalToConstant: 0)
        confirmPasswordLabelHeightConstraint = confirmPasswordLabel.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: StatusBarManager.shared.statusBarHeight + 10),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            closeButton.heightAnchor.constraint(equalToConstant: 44),
            
            emailLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 40),
            emailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            emailLabelHeightConstraint,
            
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 2),
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            emailTextField.heightAnchor.constraint(equalToConstant: 60),
            
            nameLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: emailLabel.leadingAnchor),
            nameLabelHeightConstraint,
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            nameTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            nameTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
            
            passwordLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10),
            passwordLabel.leadingAnchor.constraint(equalTo: emailLabel.leadingAnchor),
            passwordLabelHeightConstraint,
            
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 2),
            passwordTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: nameTextField.heightAnchor),
            
            confirmPasswordLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            confirmPasswordLabel.leadingAnchor.constraint(equalTo: emailLabel.leadingAnchor),
            confirmPasswordLabelHeightConstraint,
            
            confirmPasswordTextField.topAnchor.constraint(equalTo: confirmPasswordLabel.bottomAnchor, constant: 2),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            confirmPasswordTextField.heightAnchor.constraint(equalTo: passwordTextField.heightAnchor),
            
            doneButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 30),
            doneButton.leadingAnchor.constraint(equalTo: confirmPasswordTextField.leadingAnchor),
            doneButton.trailingAnchor.constraint(equalTo: confirmPasswordTextField.trailingAnchor),
            doneButton.heightAnchor.constraint(equalTo: confirmPasswordTextField.heightAnchor)
        ])
    }
    
    private func configureLabel(_ label: UILabel, text: String) {
        label.text = text
        label.applyDynamicTypeFont(textStyle: .subheadline, size: 13, weight: .medium)
        label.textColor = .mainGreenColor
        label.alpha = 0
    }
}
