//
//  SignUpViewModel.swift
//  GIL
//
//  Created by 송우진 on 4/1/24.
//

import Combine
import Foundation

class SignUpViewModel {
    var emailPublisher = CurrentValueSubject<String, Never>("")
    var namePublisher = CurrentValueSubject<String, Never>("")
    var passwordPublisher = CurrentValueSubject<String, Never>("")
    var confirmPasswordPublisher = CurrentValueSubject<String, Never>("")
    var isFormValidPublisher = CurrentValueSubject<Bool, Never>(false)
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        setupFormValidation()
    }
    
    private func setupFormValidation() {
        Publishers.CombineLatest4(emailPublisher, namePublisher, passwordPublisher, confirmPasswordPublisher)
            .map { email, name, password, confirmPassword in
                return email.isValidEmail() &&
                       !name.isEmpty &&
                       password.isValidPassword() &&
                       confirmPassword == password
            }
            .subscribe(isFormValidPublisher)
            .store(in: &cancellables)
    }

    
}
