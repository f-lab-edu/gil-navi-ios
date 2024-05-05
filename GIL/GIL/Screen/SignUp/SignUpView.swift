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
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Updates
extension SignUpView {
    func animateLabelVisibility(
        _ label: UILabel,
        shouldShow: Bool,
        constraint: NSLayoutConstraint
    ) {
        UIView.animate(withDuration: 0.3) {
            label.alpha = shouldShow ? 1.0 : 0
            constraint.constant = shouldShow ? 16 : 0
            self.setupComponents()
            self.layoutIfNeeded()
        }
    }
    
    func updatePasswordValidationLabels(_ validations: [Bool]) {
        let labels = [ checkPasswordLabel_01, checkPasswordLabel_02, checkPasswordLabel_03, checkPasswordLabel_04]
        for (index, label) in labels.enumerated() {
            let isValid = (index < validations.count) ? validations[index] : false
            label.textColor = isValid ? .mainGreen : .text
        }
    }
}

// MARK: - Setup UI
extension SignUpView {
    private func setupUI() {
        backgroundColor = .systemBackground
        addSubviews()
        setupComponents()
    }
    
    private func addSubviews() {
        [closeButton, emailLabel, emailTextField, nameLabel, nameTextField, passwordLabel, passwordTextField, verifyPasswordLabel, verifyPasswordTextField, doneButton, checkPasswordStackView].forEach ({ addSubview($0) })
        [checkPasswordLabel_01, checkPasswordLabel_02, checkPasswordLabel_03, checkPasswordLabel_04].forEach({ checkPasswordStackView.addArrangedSubview($0) })
    }
    
    private func setupComponents() {
        setupCloseButton()
        setupEmail()
        setupName()
        setupPassword()
        setupVerifyPassword()
        setupCheckPasswordStackView()
        setupDoneButton()
    }
    
    private func setupCloseButton() {
        closeButton
            .top(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10)
            .left(equalTo: leadingAnchor, constant: 10)
            .size(CGSize(width: 44, height: 44))
    }
    
    private func setupEmail() {
        emailLabel
            .top(equalTo: closeButton.bottomAnchor, constant: 15)
            .left(equalTo: leadingAnchor, constant: 20)
            .height(emailLabelHeightConstraint.constant)
        emailTextField
            .top(equalTo: emailLabel.bottomAnchor, constant: 2)
            .left(equalTo: leadingAnchor, constant: 16)
            .right(equalTo: trailingAnchor, constant: -16)
            .height(60)
    }
    
    private func setupName() {
        nameLabel
            .top(equalTo: emailTextField.bottomAnchor, constant: 10)
            .applyConstraints(to: emailLabel, attributes: [.leading])
            .height(nameLabelHeightConstraint.constant)
        nameTextField
            .top(equalTo: nameLabel.bottomAnchor, constant: 2)
            .applyConstraints(to: emailTextField, attributes: [.leading, .trailing, .height])
    }
    
    private func setupPassword() {
        passwordLabel
            .top(equalTo: nameTextField.bottomAnchor, constant: 10)
            .applyConstraints(to: emailLabel, attributes: [.leading])
            .height(passwordLabelHeightConstraint.constant)
        passwordTextField
            .top(equalTo: passwordLabel.bottomAnchor, constant: 2)
            .applyConstraints(to: emailTextField, attributes: [.leading, .trailing, .height])
    }
    
    private func setupVerifyPassword() {
        verifyPasswordLabel
            .top(equalTo: passwordTextField.bottomAnchor, constant: 10)
            .applyConstraints(to: emailLabel, attributes: [.leading])
            .height(verifyPasswordLabelHeightConstraint.constant)
        verifyPasswordTextField
            .top(equalTo: verifyPasswordLabel.bottomAnchor, constant: 2)
            .applyConstraints(to: emailTextField, attributes: [.leading, .trailing, .height])
    }
    
    private func setupCheckPasswordStackView() {
        checkPasswordStackView
            .top(equalTo: verifyPasswordTextField.bottomAnchor, constant: 15)
            .left(equalTo: verifyPasswordTextField.leadingAnchor, constant: 10)
            .right(equalTo: verifyPasswordTextField.trailingAnchor, constant: -10)
    }
    
    private func setupDoneButton() {
        doneButton
            .top(equalTo: checkPasswordStackView.bottomAnchor, constant: 30)
            .applyConstraints(to: emailTextField, attributes: [.leading, .trailing, .height])
    }
}
