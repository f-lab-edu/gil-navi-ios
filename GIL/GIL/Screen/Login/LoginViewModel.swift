//
//  LoginViewModel.swift
//  GIL
//
//  Created by 송우진 on 3/25/24.
//

import Foundation
import Combine
import AuthenticationServices
import OSLog

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

                var args: [String : Any] = [
                    "userIdentifier" : userIdentifier,
                    "fullName" : fullName?.debugDescription ?? "",
                    "email" : email?.debugDescription ?? ""
                ]
                
                if let authorizationCode = appleIDCredential.authorizationCode,
                   let identityToken = appleIDCredential.identityToken,
                   let authString = String(data: authorizationCode, encoding: .utf8),
                   let tokenString = String(data: identityToken, encoding: .utf8) {
                    args.updateValue(authString, forKey: "authorizationCode")
                    args.updateValue(tokenString, forKey: "identityToken")

                }
                Log.network("ASAuthorizationAppleIDCredential", args)

            case let passwordCredential as ASPasswordCredential:
                let username = passwordCredential.user
                let password = passwordCredential.password
                Log.network("ASPasswordCredential", [
                    "username" : username,
                    "password" : password
                ])
                
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
