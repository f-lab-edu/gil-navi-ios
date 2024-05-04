//
//  LoginViewModel.swift
//  GIL
//
//  Created by 송우진 on 3/25/24.
//

import Foundation
import Combine
import AuthenticationServices
import FirebaseAuth

protocol LoginViewModelInput {
    func startSignInWithAppleFlow()
    func signInWithEmail(email: String, password: String)
}

protocol LoginViewModelOutput {
    var loginPublisher: PassthroughSubject<Void, Error> { get set }
}

protocol LoginViewModelIO: LoginViewModelInput & LoginViewModelOutput { }

final class LoginViewModel: NSObject, LoginViewModelIO {
    enum LoginError: Error {
        case appleIDCredentialRetrievalFailed
        case invalidNonceOrIDToken
        
        var errorDescription: String {
            switch self {
            case .appleIDCredentialRetrievalFailed:
                return "Apple ID 자격 증명을 가져오는 데 실패했습니다."
            case .invalidNonceOrIDToken:
                return "Nonce 또는 ID 토큰이 유효하지 않습니다."
            }
        }
    }
    
    var loginPublisher = PassthroughSubject<Void, Error>()
    var isFormValidPublisher = CurrentValueSubject<Bool, Never>(false)
    var cancellables = Set<AnyCancellable>()
    
    private var currentNonce: String?
    
    func startSignInWithAppleFlow() {
        do {
            let nonce = try CryptoUtils.randomNonceString()
            currentNonce = nonce
            let appleProvider = ASAuthorizationAppleIDProvider()
            let request = appleProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            request.nonce = CryptoUtils.sha256(nonce)
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.performRequests()
        } catch {
            loginPublisher.send(completion: .failure(error))
        }
    }
    
    func signInWithEmail(
        email: String,
        password: String
    ) {
        Task {
            do {
                let _ = try await FirebaseAuthManager.signInAsync(with: email, password: password)
            } catch {
                loginPublisher.send(completion: .failure(error))
            }
        }
    }
    
    private func performAppleLogin(authorization: ASAuthorization) {
        Task {
            do {
                guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { throw LoginError.appleIDCredentialRetrievalFailed }
                
                guard let nonce = currentNonce,
                      let appleIDToken = appleIDCredential.identityToken,
                      let idTokenString = String(data: appleIDToken, encoding: .utf8)
                else { throw LoginError.invalidNonceOrIDToken }
                
                let credential = OAuthProvider.appleCredential(withIDToken: idTokenString, rawNonce: nonce, fullName: appleIDCredential.fullName)
                let _ = try await FirebaseAuthManager.signInAsync(with: credential)
            } catch {
                loginPublisher.send(completion: .failure(error))
            }
        }
    }
    
    func errorMessage(for error: Error) -> String {
        switch error {
        case let loginError as LoginError: return loginError.errorDescription
        case let cryptoUtilsError as CryptoUtilsError: return cryptoUtilsError.localizedDescription
        default: return error.localizedDescription
        }
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension LoginViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        performAppleLogin(authorization: authorization)
    }

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        loginPublisher.send(completion: .failure(error))
    }
}
