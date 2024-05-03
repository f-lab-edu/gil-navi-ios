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

protocol LoginViewModelInput {
    func startSignInWithAppleFlow()
}

protocol LoginViewModelOutput {
    var loginPublisher: PassthroughSubject<Void, Error> { get set }
}

protocol LoginViewModelIO: LoginViewModelInput & LoginViewModelOutput { }

class LoginViewModel: NSObject, LoginViewModelIO {
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
    
    private func performAppleLogin(authorization: ASAuthorization) {
        Task {
            do {
                guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { throw LoginError.appleIDCredentialRetrievalFailed }
                
                guard let nonce = currentNonce,
                      let appleIDToken = appleIDCredential.identityToken,
                      let idTokenString = String(data: appleIDToken, encoding: .utf8)
                else { throw LoginError.invalidNonceOrIDToken }
                
                let credential = OAuthProvider.appleCredential(withIDToken: idTokenString, rawNonce: nonce, fullName: appleIDCredential.fullName)
                
                switch await FirebaseAuthService.signIn(with: credential) {
                case .success(_): loginPublisher.send(completion: .finished)
                case .failure(let error): throw error
                }
            } catch {
                loginPublisher.send(completion: .failure(error))
            }
        }
    }
    
    func errorMessage(for error: Error) -> String {
        if let loginError = error as? LoginError {
            return loginError.errorDescription
        } else if let firebaseAuthError = error as? FirebaseAuthError {
            return firebaseAuthError.errorDescription
        } else if let cryptoUtilsError = error as? CryptoUtilsError {
            return cryptoUtilsError.localizedDescription
        } else {
            return "로그인 중 예상치 못한 오류가 발생했습니다. 잠시 후 다시 시도해 주세요."
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
