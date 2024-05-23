//
//  SignUpViewController.swift
//  GIL
//
//  Created by 송우진 on 3/26/24.
//

import UIKit
import Combine

final class SignUpViewController: BaseViewController {
    private var cancellables: Set<AnyCancellable> = []
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
        signUpView.closeButton.addAction(UIAction { [weak self] _ in self?.closeButtonTapped()}, for: .touchUpInside)
        signUpView.doneButton.addAction(UIAction { [weak self] _ in self?.signUpButtonTapped()}, for: .touchUpInside)
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
            .sink { signUpResult in
                switch signUpResult {
                case .success(_): ToastManager.shared.showToast(message: "회원가입 성공")
                case .failure(let errorMessage): AlertService.showAlert(title: "회원가입 실패", message: errorMessage)
                case .none: break
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupBindEmailValidation() {
        viewModel.emailPublisher
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] email in
                self?.signUpView.emailTextField.updateBorderColor(email.isValidEmail())
            }
            .store(in: &cancellables)
    }
    
    private func setupBindNameValidation() {
        viewModel.namePublisher
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] name in
                self?.signUpView.nameTextField.updateBorderColor(!name.isEmpty)
            }
            .store(in: &cancellables)
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
                self?.signUpView.passwordTextField.updateBorderColor(result.isValid)
                self?.signUpView.updatePasswordValidationLabels(result.validations)
            }
            .store(in: &cancellables)
    }
    
    private func setupBindPasswordMatched() {
        viewModel.passwordMatchPublisher
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isMatch in
                self?.signUpView.verifyPasswordTextField.updateBorderColor(isMatch)
            }
            .store(in: &cancellables)
    }

    private func setupBindFormValidation() {
        viewModel.isFormValidPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                self?.signUpView.doneButton.isEnabled = isValid
            }
            .store(in: &cancellables)
    }
}

// MARK: - Actions
extension SignUpViewController {
    private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    private func signUpButtonTapped() {
        viewModel.signUp()
    }
}
