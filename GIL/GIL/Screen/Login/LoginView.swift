//
//  LoginView.swift
//  GIL
//
//  Created by 송우진 on 3/21/24.
//

import UIKit

final class LoginView: UIView {
    private let formStackView = BaseStackView(axis: .vertical, spacing: 10)
    private let singUpStackView = BaseStackView(axis: .horizontal, distribution: .fill, spacing: 3)
    let emailTextField = FormTextField(type: .email, returnKeyType: .next)
    let passwordTextField = FormTextField(type: .password, returnKeyType: .done)
    let loginButton = UIButton()
    let signUpLabel = BaseLabel(text: "아직 회원이 아니신가요?", fontSize: 15)
    let socialLabel = BaseLabel(text: "SNS 계정으로 로그인", textColor: .lightGray, fontType: .footnote, fontSize: 15)
    let signUpButton = UIButton()
    let appleLoginButton = UIButton()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Setup UI
extension LoginView {
    private func setupUI() {
        addSubviews()
        setupComponents()
    }
    
    private func addSubviews() {
        [formStackView, loginButton, singUpStackView, socialLabel, appleLoginButton].forEach({ addSubview($0) })
        [emailTextField, passwordTextField].forEach({ formStackView.addArrangedSubview($0) })
        [signUpLabel, signUpButton].forEach({ singUpStackView.addArrangedSubview($0) })
    }
    
    private func setupComponents() {
        setupForm()
        setupLoginButton()
        setupSingUpStackView()
        setupSocialLabel()
        setupAppleLoginButton()
    }
    
    private func setupForm() {
        emailTextField
            .setAccessibilityIdentifier("EmailTextField")
            .setAccessibility(label: "이메일 입력 필드", hint: "이메일을 입력하세요")
        passwordTextField
            .setAccessibilityIdentifier("PasswordTextField")
            .setAccessibility(label: "비밀번호 입력 필드", hint: "비밀번호를 입력하세요")
        formStackView
            .top(equalTo: topAnchor, constant: 120)
            .left(equalTo: leadingAnchor, constant: 16)
            .right(equalTo: trailingAnchor, constant: -16)
            .height(120)
    }
    
    private func setupLoginButton() {
        loginButton
            .setAccessibilityIdentifier("SignInButton")
            .setAccessibility(label: "로그인 버튼", hint: "로그인하려면 눌러주세요", traits: .button)
            .configureSubmitStyle(title: "로그인")
            .top(equalTo: formStackView.bottomAnchor, constant: 30)
            .applyConstraints(to: formStackView, attributes: [.leading, .trailing])
            .height(60)
    }
    
    private func setupSingUpStackView() {
        signUpLabel.setAccessibility(label: "아직 회원이 아니신가요?")
        signUpButton
            .setAccessibilityIdentifier("SignUpButton")
            .setAccessibility(label: "회원가입 버튼", hint: "회원가입하려면 눌러주세요", traits: .button)
            .setTitle(title: "회원가입", state: .normal)
            .setTitleColor(color: .red, state: .normal)
            .setFont(textStyle: .body, size: 15, weight: .semibold)
        singUpStackView
            .top(equalTo: loginButton.bottomAnchor, constant: 40)
            .centerX(equalTo: centerXAnchor)
    }
    
    private func setupSocialLabel() {
        socialLabel
            .setAccessibility(label: "SNS 계정으로 로그인 안내")
            .centerX(equalTo: centerXAnchor)
            .bottom(equalTo: bottomAnchor, constant: -120)
    }
    
    private func setupAppleLoginButton() {
        appleLoginButton
            .setAccessibility(label: "Apple 로그인 버튼", hint: "Apple 계정으로 로그인하려면 눌러주세요", traits: .button)
            .setLayer(cornerRadius: 25)
            .setBackgroundImage(image: UIImage(named: "logo-apple"), state: .normal)
            .top(equalTo: socialLabel.bottomAnchor, constant: 20)
            .centerX(equalTo: socialLabel.centerXAnchor)
            .size(CGSize(width: 50, height: 50))
    }
}
