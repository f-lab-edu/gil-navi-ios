//
//  LoginViewModel.swift
//  GIL
//
//  Created by 송우진 on 3/25/24.
//

import Foundation
import Combine
import AuthenticationServices

protocol LoginViewModelIntput {
    func didTappedLoginButton()
}

protocol LoginViewModelOutput {
    var loginPublisher: PassthroughSubject<Void, Error> { get set }
}

protocol LoginViewModelIO: LoginViewModelIntput & LoginViewModelOutput { }


class LoginViewModel: NSObject, LoginViewModelIO {
    var loginPublisher = PassthroughSubject<Void, Error>()
    var cancellables = Set<AnyCancellable>()
    
    func didTappedLoginButton() {
        let appleProvider = ASAuthorizationAppleIDProvider()
        let request = appleProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }
    
    
    override init() {
        super.init()
    }
    
    
    
}

// MARK: - ASAuthorizationControllerDelegate
extension LoginViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
            switch authorization.credential {
            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                let userIdentifier = appleIDCredential.user
                let fullName = appleIDCredential.fullName
                let email = appleIDCredential.email

                if let authorizationCode = appleIDCredential.authorizationCode,
                   let identityToken = appleIDCredential.identityToken,
                   let authString = String(data: authorizationCode, encoding: .utf8),
                   let tokenString = String(data: identityToken, encoding: .utf8) {
                    print("authString: \(authString)")
                    print("tokenString: \(tokenString)")

                }
                print("useridentifier: \(userIdentifier)")
                print("fullName: \(fullName)")
                print("email: \(email)")

            case let passwordCredential as ASPasswordCredential:
                let username = passwordCredential.user
                let password = passwordCredential.password

                print("username: \(username)")
                print("password: \(password)")

            default:
                break
            }
        }

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        loginPublisher.send(completion: .failure(error))
    }
}
