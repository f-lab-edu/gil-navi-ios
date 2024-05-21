//
//  AuthenticationUseCase.swift
//  GIL
//
//  Created by 송우진 on 5/21/24.
//

import Foundation
import Combine
import AuthenticationServices

enum AuthenticationError: Error {
    case invalidAppleIDCredentials
    case appleSignInFailed(reason: String)
    case invalidNonceOrIDToken
    var errorDescription: String {
        switch self {
        case .invalidAppleIDCredentials: return "Apple ID 자격 증명이 유효하지 않습니다."
        case .appleSignInFailed(let reason): return "Apple 로그인에 실패했습니다: \(reason)"
        case .invalidNonceOrIDToken: return "제공된 Nonce 또는 ID 토큰이 유효하지 않습니다."
        }
    }
}

protocol AuthenticationUseCase {
    func signInAnonymously() -> AnyPublisher<Member?, Error>
    func signInWithEmail(email: String, password: String) -> AnyPublisher<Member?, Error>
    func signInWithApple(authorization: ASAuthorization) -> AnyPublisher<Member?, Error>
    func prepareAppleSignIn() -> AnyPublisher<ASAuthorizationController, Error>
    func signUp(email: String, name: String, password: String ) -> AnyPublisher<Member?, Error>
}

final class DefaultAuthenticationUseCase: AuthenticationUseCase {
    private let firebaseAuthManager: FirebaseAuthManaging
    private var currentNonce: String?
    
    // MARK: - Initialization
    init(firebaseAuthManager: FirebaseAuthManaging) {
        self.firebaseAuthManager = firebaseAuthManager
    }
}

extension DefaultAuthenticationUseCase {
    func signInAnonymously() -> AnyPublisher<Member?, Error> {
        firebaseAuthManager.signInAnonymously()
    }
    
    func signInWithEmail(
        email: String,
        password: String
    ) -> AnyPublisher<Member?, Error> {
        firebaseAuthManager.signInWithEmail(email: email, password: password)
    }
    
    func signInWithApple(authorization: ASAuthorization) -> AnyPublisher<Member?, Error> {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let nonce = currentNonce,
              let appleIDToken = appleIDCredential.identityToken,
              let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            return Fail(error: AuthenticationError.invalidAppleIDCredentials).eraseToAnyPublisher()
        }
        return firebaseAuthManager.signInWithApple(idTokenString: idTokenString, nonce: nonce, fullName: appleIDCredential.fullName)
    }
    
    func prepareAppleSignIn() -> AnyPublisher<ASAuthorizationController, Error> {
        Deferred {
            Future { [weak self] promise in
                guard let self else { return }
                do {
                    let nonce = try CryptoUtils.randomNonceString()
                    self.currentNonce = nonce
                    let appleProvider = ASAuthorizationAppleIDProvider()
                    let request = appleProvider.createRequest()
                    request.requestedScopes = [.fullName, .email]
                    request.nonce = CryptoUtils.sha256(nonce)

                    let controller = ASAuthorizationController(authorizationRequests: [request])
                    promise(.success(controller))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func signUp(
        email: String,
        name: String,
        password: String
    ) -> AnyPublisher<Member?, Error> {
        firebaseAuthManager.createUser(email: email, password: password, name: name)
    }
}
