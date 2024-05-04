//
//  SignUpViewModel.swift
//  GIL
//
//  Created by 송우진 on 4/1/24.
//

import Combine
import Foundation

protocol SignUpViewModelInput {
    var emailPublisher: CurrentValueSubject<String, Never> { get }
    var namePublisher: CurrentValueSubject<String, Never> { get }
    var passwordPublisher: CurrentValueSubject<String, Never> { get }
    var verifyPasswordPublisher: CurrentValueSubject<String, Never> { get }
    func createUser() async
}

protocol SignUpViewModelOutput {
    var isFormValidPublisher: CurrentValueSubject<Bool, Never> { get }
    var passwordMatchPublisher: CurrentValueSubject<Bool, Never> { get }
    var createUserPublisher: PassthroughSubject<Void, Error> { get }
}

class SignUpViewModel: SignUpViewModelInput, SignUpViewModelOutput {
    enum SignUpError: Error {
        case invalidEmail
        case nameRequired
        case passwordNotStrongEnough
        case passwordsDoNotMatch
    }
    
    var emailPublisher = CurrentValueSubject<String, Never>("")
    var namePublisher = CurrentValueSubject<String, Never>("")
    var passwordPublisher = CurrentValueSubject<String, Never>("")
    var verifyPasswordPublisher = CurrentValueSubject<String, Never>("")
    var isFormValidPublisher = CurrentValueSubject<Bool, Never>(false)
    var passwordMatchPublisher = CurrentValueSubject<Bool, Never>(false)
    var createUserPublisher = PassthroughSubject<Void, Error>()
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        bindFormValidation()
        bindPasswordMatch()
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
    
    func createUser() async {
        do {
            try validateInputs()
            let _ = try await FirebaseAuthManager.createUserAsync(with: emailPublisher.value, password: verifyPasswordPublisher.value)
        } catch {
            createUserPublisher.send(completion: .failure(error))
        }
    }
    
    private func validateInputs() throws {
        guard emailPublisher.value.isValidEmail() else { throw SignUpError.invalidEmail }
        guard !namePublisher.value.isEmpty else { throw SignUpError.nameRequired }
        guard passwordPublisher.value.isValidPassword() else { throw SignUpError.passwordNotStrongEnough }
        guard passwordPublisher.value == verifyPasswordPublisher.value else { throw SignUpError.passwordsDoNotMatch }
    }
    
    func errorMessage(for error: Error) -> String {
        switch error {
        case let signUpError as SignUpError: return signUpError.errorDescription
        default: return error.localizedDescription
        }
    }

}

// MARK: - SignUpError
extension SignUpViewModel.SignUpError {
    var errorDescription: String {
        switch self {
        case .invalidEmail:
            return "입력하신 이메일이 유효하지 않습니다. 올바른 이메일 주소를 입력해 주세요."
        case .nameRequired:
            return "이름을 입력해주세요."
        case .passwordNotStrongEnough:
            return "비밀번호가 충분히 강력하지 않습니다. 비밀번호는 최소 10자 이상이어야 하며, 숫자, 대문자, 특수 문자를 포함해야 합니다."
        case .passwordsDoNotMatch:
            return "입력한 비밀번호가 일치하지 않습니다. 비밀번호를 다시 확인해 주세요."
        }
    }
}
