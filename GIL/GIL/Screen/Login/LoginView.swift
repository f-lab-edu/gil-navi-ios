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
            .setAccessibilityIdentifier("LoginViewEmailTextField")
            .setAccessibility(label: "이메일 입력 필드", hint: "이메일을 입력하세요")
        passwordTextField
            .setAccessibilityIdentifier("LoginViewPasswordTextField")
            .setAccessibility(label: "비밀번호 입력 필드", hint: "비밀번호를 입력하세요")
        formStackView.makeConstraints {
            $0.top(equalTo: topAnchor, constant: 120)
            $0.matchParent(self, attributes: [.leading, .trailing], insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
            $0.height(equalToConstant: 120)
        }
    }
    
    private func setupLoginButton() {
        loginButton
            .setAccessibilityIdentifier("LoginViewSignInButton")
            .setAccessibility(label: "로그인 버튼", hint: "로그인하려면 눌러주세요", traits: .button)
            .configureSubmitStyle(title: "로그인")
            .makeConstraints({
                $0.top(equalTo: formStackView.bottomAnchor, constant: 30)
                $0.matchParent(formStackView, attributes: [.leading, .trailing])
                $0.height(equalToConstant: 60)
            })
    }
    
    private func setupSingUpStackView() {
        signUpLabel.setAccessibility(label: "아직 회원이 아니신가요?")
        signUpButton
            .setAccessibilityIdentifier("LoginViewSignUpButton")
            .setAccessibility(label: "회원가입 버튼", hint: "회원가입하려면 눌러주세요", traits: .button)
            .setTitle(title: "회원가입", state: .normal)
            .setTitleColor(color: .red, state: .normal)
            .setFont(textStyle: .body, size: 15, weight: .semibold)
        singUpStackView.makeConstraints({
            $0.top(equalTo: loginButton.bottomAnchor, constant: 40)
            $0.centerX(equalTo: centerXAnchor)
        })
    }
    
    private func setupSocialLabel() {
        socialLabel
            .setAccessibility(label: "SNS 계정으로 로그인 안내")
            .makeConstraints({
                $0.centerX(equalTo: centerXAnchor)
                $0.bottom(equalTo: bottomAnchor, constant: 120)
            })
    }
    
    private func setupAppleLoginButton() {
        appleLoginButton
            .setAccessibility(label: "Apple 로그인 버튼", hint: "Apple 계정으로 로그인하려면 눌러주세요", traits: .button)
            .setLayer(cornerRadius: 25)
            .setBackgroundImage(image: UIImage(named: "logo-apple"), state: .normal)
            .makeConstraints({
                $0.top(equalTo: socialLabel.bottomAnchor, constant: 20)
                $0.centerX(equalTo: socialLabel.centerXAnchor)
                $0.size(CGSize(width: 50, height: 50))
            })
    }
}
