//
//  SignUpView.swift
//  GIL
//
//  Created by 송우진 on 3/26/24.
//

import UIKit

final class SignUpView: UIView {
    private let checkPasswordStackView = BaseStackView(spacing: 5)
    let closeButton = NavigationActionButton()
    let emailLabel = BaseLabel(text: "이메일", textColor: .mainGreen, fontType: .subheadline)
    let nameLabel = BaseLabel(text: "이름", textColor: .mainGreen, fontType: .subheadline)
    let passwordLabel = BaseLabel(text: "비밀번호", textColor: .mainGreen, fontType: .subheadline)
    let verifyPasswordLabel = BaseLabel(text: "비밀번호 확인", textColor: .mainGreen, fontType: .subheadline)
    let emailTextField = FormTextField(type: .email, returnKeyType: .next, clearButtonMode: .whileEditing)
    let nameTextField = FormTextField(type: .unknown(placeholder: "이름"), returnKeyType: .next, clearButtonMode: .whileEditing)
    let passwordTextField = FormTextField(type: .password, returnKeyType: .next)
    let verifyPasswordTextField = FormTextField(type: .verifyPassword, returnKeyType: .done)
    let doneButton = InteractiveButton(title: "완료", titleColor: .white, fontSize: 18, fontWeight: .bold)
    let checkPasswordLabel_01 = BaseLabel(text: "· 10글자 이상", fontSize: 11)
    let checkPasswordLabel_02 = BaseLabel(text: "· 대문자 포함", fontSize: 11)
    let checkPasswordLabel_03 = BaseLabel(text: "· 숫자 포함", fontSize: 11)
    let checkPasswordLabel_04 = BaseLabel(text: "· 특수 문자 포함 !@#$%^&*()-_=+[{]}\\|;:'\",<.>/?", fontSize: 11)
    
    lazy var emailLabelHeightConstraint: NSLayoutConstraint = emailLabel.heightAnchor.constraint(equalToConstant: 0)
    lazy var nameLabelHeightConstraint: NSLayoutConstraint = nameLabel.heightAnchor.constraint(equalToConstant: 0)
    lazy var passwordLabelHeightConstraint: NSLayoutConstraint = passwordLabel.heightAnchor.constraint(equalToConstant: 0)
    lazy var verifyPasswordLabelHeightConstraint: NSLayoutConstraint = verifyPasswordLabel.heightAnchor.constraint(equalToConstant: 0)
    
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
        configureLabel(verifyPasswordLabel, text: "비밀번호 확인")
        
        [closeButton, emailLabel, emailTextField, nameLabel, nameTextField, passwordLabel, passwordTextField, verifyPasswordLabel, verifyPasswordTextField, doneButton, checkPasswordStackView].forEach ({
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        [checkPasswordLabel_01, checkPasswordLabel_02, checkPasswordLabel_03, checkPasswordLabel_04].forEach({
            checkPasswordStackView.addArrangedSubview($0)
        })
    }
    
    func makeConstraints() {
        emailLabelHeightConstraint = emailLabel.heightAnchor.constraint(equalToConstant: 0)
        nameLabelHeightConstraint = nameLabel.heightAnchor.constraint(equalToConstant: 0)
        passwordLabelHeightConstraint = passwordLabel.heightAnchor.constraint(equalToConstant: 0)
        verifyPasswordLabelHeightConstraint = verifyPasswordLabel.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            closeButton.heightAnchor.constraint(equalToConstant: 44),
            
            emailLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 15),
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
            
            verifyPasswordLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            verifyPasswordLabel.leadingAnchor.constraint(equalTo: emailLabel.leadingAnchor),
            verifyPasswordLabelHeightConstraint,
            
            verifyPasswordTextField.topAnchor.constraint(equalTo: verifyPasswordLabel.bottomAnchor, constant: 2),
            verifyPasswordTextField.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            verifyPasswordTextField.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            verifyPasswordTextField.heightAnchor.constraint(equalTo: passwordTextField.heightAnchor),
            
            checkPasswordStackView.topAnchor.constraint(equalTo: verifyPasswordTextField.bottomAnchor, constant: 15),
            checkPasswordStackView.leadingAnchor.constraint(equalTo: verifyPasswordTextField.leadingAnchor, constant: 10),
            checkPasswordStackView.trailingAnchor.constraint(equalTo: verifyPasswordTextField.trailingAnchor, constant: -10),
            
            doneButton.topAnchor.constraint(equalTo: checkPasswordStackView.bottomAnchor, constant: 30),
            doneButton.leadingAnchor.constraint(equalTo: verifyPasswordTextField.leadingAnchor),
            doneButton.trailingAnchor.constraint(equalTo: verifyPasswordTextField.trailingAnchor),
            doneButton.heightAnchor.constraint(equalTo: verifyPasswordTextField.heightAnchor)
        ])
    }
    
    private func configureLabel(_ label: UILabel, text: String) {
        label.text = text.localized()
        label.applyDynamicTypeFont(textStyle: .subheadline, size: 13, weight: .medium)
        label.textColor = .mainGreen
        label.alpha = 0
    }
}
