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
import CryptoKit
import FirebaseAuth

protocol LoginViewModelIntput {
    func startSignInWithAppleFlow()
}

protocol LoginViewModelOutput {
    var loginPublisher: PassthroughSubject<Void, Error> { get set }
}

protocol LoginViewModelIO: LoginViewModelIntput & LoginViewModelOutput { }


class LoginViewModel: NSObject, LoginViewModelIO {
    
    var loginPublisher = PassthroughSubject<Void, Error>()
    var cancellables = Set<AnyCancellable>()
    
    private var currentNonce: String?
    
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleProvider = ASAuthorizationAppleIDProvider()
        let request = appleProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
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
        
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            let error = NSError(domain: "LoginError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to retrieve Apple ID credential"])
            loginPublisher.send(completion: .failure(error))
            return
        }
        
        guard let nonce = currentNonce,
              let appleIDToken = appleIDCredential.identityToken,
              let idTokenString = String(data: appleIDToken, encoding: .utf8)
        else {
            let error = NSError(domain: "LoginError", code: -2, userInfo: [NSLocalizedDescriptionKey: "Invalid nonce or id token"])
            loginPublisher.send(completion: .failure(error))
            return
        }
        
        let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                       rawNonce: nonce,
                                                       fullName: appleIDCredential.fullName)
        
        
        Auth.auth().signIn(with: credential) { result, error in
            if let error = error {
                self.loginPublisher.send(completion: .failure(error))
                return
            }
            
            guard result != nil else {
                let error = NSError(domain: "LoginError", code: -3, userInfo: [NSLocalizedDescriptionKey: "Firebase authentication failed"])
                self.loginPublisher.send(completion: .failure(error))
                return
            }

            self.loginPublisher.send(completion: .finished)
        }
        
    }

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        loginPublisher.send(completion: .failure(error))
    }
}

// MARK: - Apple Login
extension LoginViewModel {

    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }

      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

      let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
      }

      return String(nonce)
    }

    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
}


