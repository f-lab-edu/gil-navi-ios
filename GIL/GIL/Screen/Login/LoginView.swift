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
    let loginButton = InteractiveButton(title: "로그인", titleColor: .white, fontSize: 18, fontWeight: .bold)
    let signUpLabel = BaseLabel(text: "아직 회원이 아니신가요?", fontSize: 15)
    let socialLabel = BaseLabel(text: "SNS 계정으로 로그인", textColor: .grayLabel, fontType: .footnote, fontSize: 15)
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
        setupFormStackView()
        setupLoginButton()
        setupSingUpStackView()
        setupSocialLabel()
        setupAppleLoginButton()
    }
    
    private func setupFormStackView() {
        formStackView
            .top(equalTo: topAnchor, constant: 120)
            .left(equalTo: leadingAnchor, constant: 16)
            .right(equalTo: trailingAnchor, constant: -16)
            .height(120)
    }
    
    private func setupLoginButton() {
        loginButton
            .top(equalTo: formStackView.bottomAnchor, constant: 30)
            .applyConstraints(to: formStackView, attributes: [.leading, .trailing])
            .height(60)
    }
    
    private func setupSingUpStackView() {
        singUpStackView
            .top(equalTo: loginButton.bottomAnchor, constant: 40)
            .centerX(equalTo: centerXAnchor)
    }
    
    private func setupSocialLabel() {
        socialLabel
            .centerX(equalTo: centerXAnchor)
            .bottom(equalTo: bottomAnchor, constant: -120)
    }
    
    private func setupAppleLoginButton() {
        appleLoginButton.layer.cornerRadius = 25
        appleLoginButton
            .top(equalTo: socialLabel.bottomAnchor, constant: 20)
            .centerX(equalTo: socialLabel.centerXAnchor)
            .size(CGSize(width: 50, height: 50))
    }
}
