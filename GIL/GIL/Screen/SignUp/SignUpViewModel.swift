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
    var verifyPasswordPublisher = CurrentValueSubject<String, Never>("")
    var isFormValidPublisher = CurrentValueSubject<Bool, Never>(false)
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        setupFormValidation()
    }
    
    private func setupFormValidation() {
        Publishers.CombineLatest4(emailPublisher, namePublisher, passwordPublisher, verifyPasswordPublisher)
            .map { email, name, password, verifyPassword in
                return email.isValidEmail() &&
                       !name.isEmpty &&
                       password.isValidPassword() &&
                       verifyPassword == password
            }
            .subscribe(isFormValidPublisher)
            .store(in: &cancellables)
    }

    
    func validateAlphaNumericString(inputString: String) -> Bool {
        let regex = "^[A-Za-z0-9]+$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: inputString)
    }

    
}
