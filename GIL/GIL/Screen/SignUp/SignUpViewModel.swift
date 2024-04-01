//
//  SignUpViewModel.swift
//  GIL
//
//  Created by 송우진 on 4/1/24.
//

import Combine

class SignUpViewModel {
    var emailPublisher = PassthroughSubject<String, Error>()
    var namePublisher = PassthroughSubject<String, Error>()
    var cancellables = Set<AnyCancellable>()
    
    func checkSignUpRequirements() {
        
    }
}
