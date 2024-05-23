//
//  SignUpViewModel.swift
//  GIL
//
//  Created by 송우진 on 4/1/24.
//

import Combine

enum SignUpResult {
    case none
    case success(Member?)
    case failure(String)
}

protocol SignUpViewModelInput {
    var emailPublisher: CurrentValueSubject<String, Never> { get }
    var namePublisher: CurrentValueSubject<String, Never> { get }
    var passwordPublisher: CurrentValueSubject<String, Never> { get }
    var verifyPasswordPublisher: CurrentValueSubject<String, Never> { get }
    func signUp()
}

protocol SignUpViewModelOutput {
    var isFormValidPublisher: CurrentValueSubject<Bool, Never> { get }
    var passwordMatchPublisher: CurrentValueSubject<Bool, Never> { get }
    var createUserPublisher: CurrentValueSubject<SignUpResult, Never> { get }
}

typealias SignUpViewModel = SignUpViewModelInput & SignUpViewModelOutput

final class DefaultSignUpViewModel: SignUpViewModel {
    private let authenticationUseCase: AuthenticationUseCase
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Input
    var emailPublisher = CurrentValueSubject<String, Never>("")
    var namePublisher = CurrentValueSubject<String, Never>("")
    var passwordPublisher = CurrentValueSubject<String, Never>("")
    var verifyPasswordPublisher = CurrentValueSubject<String, Never>("")
    
    // MARK: - Output
    var isFormValidPublisher = CurrentValueSubject<Bool, Never>(false)
    var passwordMatchPublisher = CurrentValueSubject<Bool, Never>(false)
    var createUserPublisher = CurrentValueSubject<SignUpResult, Never>(.none)
    
    
    // MARK: - Initialization
    init(authenticationUseCase: AuthenticationUseCase) {
        self.authenticationUseCase = authenticationUseCase
        bindFormValidation()
        bindPasswordMatch()
    }
    
    // MARK: - Private
    private func handleError(_ error: Error) {
        var errorMessage: String = ""
        switch error {
        case let authenticationError as AuthenticationError: errorMessage = authenticationError.errorDescription
        default:
            Log.error("Unknown SignUp Error", error.localizedDescription)
            errorMessage = "회원가입을 다시 시도해주세요."
        }
        createUserPublisher.send(.failure(errorMessage))
    }
    
    private func bindFormValidation() {
        Publishers.CombineLatest4(emailPublisher, namePublisher, passwordPublisher, verifyPasswordPublisher)
            .map { email, name, password, verifyPassword in
                email.isValidEmail() &&
                !name.isEmpty &&
                password.isValidPassword() &&
                (verifyPassword == password)
            }
            .assign(to: \.value, on: isFormValidPublisher)
            .store(in: &cancellables)
    }
    
    private func bindPasswordMatch() {
        Publishers.CombineLatest(passwordPublisher, verifyPasswordPublisher)
            .filter { _, verifyPassword in !verifyPassword.isEmpty }
            .map { $0 == $1 }
            .assign(to: \.value, on: passwordMatchPublisher)
            .store(in: &cancellables)
    }

}

// MARK: - Input
extension DefaultSignUpViewModel {
    func signUp() {
        authenticationUseCase.signUp(
            email: emailPublisher.value,
            name: namePublisher.value,
            password: passwordPublisher.value
        ).sink(receiveCompletion: { [weak self] completion in
            if case let .failure(error) = completion {
                self?.handleError(error)
            }
        }, receiveValue: { [weak self] member in
            self?.createUserPublisher.send(.success(member))
        })
        .store(in: &cancellables)
    }
}
