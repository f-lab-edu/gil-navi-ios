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

enum LoginResult {
    case none
    case success(Member?)
    case failure(String)
}

protocol LoginViewModelInput {
    func prepareAppleSignIn()
    func signInAnonymously()
    func signInWithEmail(email: String, password: String)
    func showSignUp()
}

protocol LoginViewModelOutput {
    var loginPublisher: CurrentValueSubject<LoginResult, Never> { get }
    var isFormValidPublisher: CurrentValueSubject<Bool, Never> { get }
}

typealias LoginViewModel = LoginViewModelInput & LoginViewModelOutput

final class DefaultLoginViewModel: NSObject, LoginViewModel {
    private let authenticationUseCase: AuthenticationUseCase
    private let actions: LoginViewModelActions?
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Output
    var loginPublisher = CurrentValueSubject<LoginResult, Never>(.none)
    var isFormValidPublisher = CurrentValueSubject<Bool, Never>(false)
    
    // MARK: - Initialization
    init(
        authenticationUseCase: AuthenticationUseCase,
        actions: LoginViewModelActions? = nil
    ) {
        self.authenticationUseCase = authenticationUseCase
        self.actions = actions
    }
    
    // MARK: - Private
    private func handleError(_ error: Error) {
        #if DEV
        switch error {
        case let authenticationError as AuthenticationError: Log.error("AuthenticationError", authenticationError.errorDescription)
        case let cryptoUtilsError as CryptoUtilsError: Log.error("CryptoUtilsError", cryptoUtilsError.localizedDescription)
        default: Log.error("Unknown Login Error", error.localizedDescription)
        }
        #endif
        loginPublisher.send(.failure("로그인을 다시 시도해주세요."))
    }
    
    private func signInWithApple(authorization: ASAuthorization) {
        authenticationUseCase.signInWithApple(authorization: authorization)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.handleError(error)
                }
            } receiveValue: { [weak self] member in
                self?.loginPublisher.send(.success(member))
            }
            .store(in: &cancellables)
    }
}

// MARK: - Input
extension DefaultLoginViewModel {
    func signInAnonymously() {
        authenticationUseCase.signInAnonymously()
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.handleError(error)
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
    
    func prepareAppleSignIn() {
        authenticationUseCase.prepareAppleSignIn()
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.handleError(error)
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
                    self?.handleError(error)
                }
            }, receiveValue: { [weak self] member in
                self?.loginPublisher.send(.success(member))
            })
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
        handleError(error)
    }
}
