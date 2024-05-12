//
//  SignUpViewController.swift
//  GIL
//
//  Created by 송우진 on 3/26/24.
//

import UIKit
import Combine

final class SignUpViewController: BaseViewController {
    private var viewModel: SignUpViewModel
    private var signUpView = SignUpView()
    private var signUpTextFieldHandler: SignUpTextFieldHandler?
    
    // MARK: - Initialization
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        signUpTextFieldHandler = SignUpTextFieldHandler(viewModel: viewModel, view: signUpView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func loadView() {
        view = signUpView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
}

// MARK: - Setup Binding
extension SignUpViewController {
    private func setupBindings() {
        setupBindButtons()
        subscribeToPublishers()
    }
    
    private func setupBindButtons() {
        signUpView.closeButton.addAction(UIAction { _ in self.closeButtonTapped()}, for: .touchUpInside)
        signUpView.doneButton.addAction(UIAction { _ in self.viewModel.createUser()}, for: .touchUpInside)
    }
    
    private func subscribeToPublishers() {
        setupBindFormCompletion()
        setupBindEmailValidation()
        setupBindNameValidation()
        setupBindPasswordValidation()
        setupBindPasswordMatched()
        setupBindFormValidation()
    }
    
    private func setupBindFormCompletion() {
        viewModel.createUserPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case .finished: Log.network("회원가입 성공")
                case .failure(let error):
                    let message = viewModel.errorMessage(for: error)
                    AlertService.showAlert(title: "회원가입 실패", message: message)
                }
            } receiveValue: { _ in }
            .store(in: &viewModel.cancellables)
    }
    
    private func setupBindEmailValidation() {
        viewModel.emailPublisher
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] email in
                guard let self else { return }
                signUpView.emailTextField.updateBorderColor(email.isValidEmail())
            }
            .store(in: &viewModel.cancellables)
    }
    
    private func setupBindNameValidation() {
        viewModel.namePublisher
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] name in
                guard let self else { return }
                signUpView.nameTextField.updateBorderColor(!name.isEmpty)
            }
            .store(in: &viewModel.cancellables)
    }
    
    private func setupBindPasswordValidation() {
        viewModel.passwordPublisher
            .dropFirst()
            .map { password -> (validations: [Bool], isValid: Bool) in
                let validations = password.validatePassword()
                let isValid = validations.allSatisfy { $0 }
                return (validations, isValid)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                signUpView.passwordTextField.updateBorderColor(result.isValid)
                signUpView.updatePasswordValidationLabels(result.validations)
            }
            .store(in: &viewModel.cancellables)
    }
    
    private func setupBindPasswordMatched() {
        viewModel.passwordMatchPublisher
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isMatch in
                guard let self else { return }
                signUpView.verifyPasswordTextField.updateBorderColor(isMatch)
            }
            .store(in: &viewModel.cancellables)
    }

    private func setupBindFormValidation() {
        viewModel.isFormValidPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                guard let self else { return }
                signUpView.doneButton.isEnabled = isValid
            }
            .store(in: &viewModel.cancellables)
    }
}

// MARK: - Actions
extension SignUpViewController {
    private func closeButtonTapped() {
        dismiss(animated: true)
    }
}
