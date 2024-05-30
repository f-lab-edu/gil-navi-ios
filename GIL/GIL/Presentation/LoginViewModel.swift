//
//  LoginViewModel.swift
//  GIL
//
//  Created by 송우진 on 3/25/24.
//

import Combine
import AuthenticationServices

struct LoginViewModelActions {
    let showSignUp: () -> Void
}

protocol LoginViewModelInput {
    func prepareAppleSignIn()
    func signInWithEmail(email: String, password: String)
    func showSignUp()
}

protocol LoginViewModelOutput {
    var errors: PassthroughSubject<Error, Never> { get }
    var isFormValidPublisher: CurrentValueSubject<Bool, Never> { get }
}

typealias LoginViewModel = LoginViewModelInput & LoginViewModelOutput

final class DefaultLoginViewModel: NSObject, LoginViewModel {
    private let authenticationUseCase: AuthenticationUseCase
    private let actions: LoginViewModelActions?
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Output
    var errors = PassthroughSubject<Error, Never>()
    var isFormValidPublisher = CurrentValueSubject<Bool, Never>(false)
    
    // MARK: - Initialization
    init(
        authenticationUseCase: AuthenticationUseCase,
        actions: LoginViewModelActions? = nil
    ) {
        self.authenticationUseCase = authenticationUseCase
        self.actions = actions
    }
    
    private func signInWithApple(authorization: ASAuthorization) {
        authenticationUseCase.signInWithApple(authorization: authorization)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.errors.send(error)
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
}

// MARK: - Input
extension DefaultLoginViewModel {
    func prepareAppleSignIn() {
        authenticationUseCase.prepareAppleSignIn()
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.errors.send(error)
                }
            }, receiveValue: { controller in
                controller.delegate = self
                controller.performRequests()
            })
            .store(in: &cancellables)
    }
    
    func signInWithEmail(
        email: String,
        password: String
    ) {
        authenticationUseCase.signInWithEmail(email: email, password: password)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.errors.send(error)
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
    
    func showSignUp() {
        actions?.showSignUp()
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension DefaultLoginViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        signInWithApple(authorization: authorization)
    }

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        errors.send(error)
    }
}
