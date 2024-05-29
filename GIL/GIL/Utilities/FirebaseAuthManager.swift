//
//  FirebaseAuthManager.swift
//  GIL
//
//  Created by 송우진 on 5/2/24.
//

import FirebaseAuth
import Combine
import AuthenticationServices

enum FirebaseAuthError: Error, Equatable {
    case invalidEmail
    case emailAlreadyInUse
    case wrongPassword
    case userNotFound
    case appleSignInFailed
    case customError(description: String)
    var errorDescription: String {
        switch self {
        case .invalidEmail: return "입력한 이메일이 유효하지 않습니다."
        case .emailAlreadyInUse: return "이미 사용 중인 이메일입니다."
        case .wrongPassword: return "잘못된 비밀번호입니다."
        case .userNotFound: return "사용자를 찾을 수 없습니다."
        case .appleSignInFailed: return "Apple 로그인에 실패했습니다."
        case .customError(let description): return description
        }
    }
}

protocol FirebaseAuthManaging {
    /// Firebase 인증 상태 변화
    var authStateDidChangePublisher: AnyPublisher<User?, Never> { get }
    func signInWithEmail(email: String, password: String) -> AnyPublisher<Member?, Error>
    func signInWithApple(idTokenString: String, nonce: String, fullName: PersonNameComponents?) -> AnyPublisher<Member?, Error>
    func createUser(email: String, password: String, name: String) -> AnyPublisher<Member?, Error>
    func signOut() -> AnyPublisher<Void, Error>
}

final class FirebaseAuthManager: FirebaseAuthManaging {
    private var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    private let authStatePublisher = PassthroughSubject<User?, Never>()
    var authStateDidChangePublisher: AnyPublisher<User?, Never> {
        authStatePublisher.eraseToAnyPublisher()
    }
    
    // MARK: - Initialization
    init() {
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.authStatePublisher.send(user)
        }
    }

    deinit {
        if let handle = authStateDidChangeListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    // MARK: - Private
    private func handleAuthError(_ error: NSError) -> FirebaseAuthError {
        switch error.code {
        case AuthErrorCode.invalidEmail.rawValue: return .invalidEmail
        case AuthErrorCode.wrongPassword.rawValue: return .wrongPassword
        case AuthErrorCode.emailAlreadyInUse.rawValue: return .emailAlreadyInUse
        case AuthErrorCode.userNotFound.rawValue: return .userNotFound
        case AuthErrorCode.accountExistsWithDifferentCredential.rawValue: return .emailAlreadyInUse
        default: return .customError(description: error.localizedDescription)
        }
    }
}

extension FirebaseAuthManager {
    func signInWithEmail(
        email: String,
        password: String
    ) -> AnyPublisher<Member?, Error> {
        Future { promise in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error as NSError? {
                    promise(.failure(self.handleAuthError(error)))
                } else {
                    promise(.success(Member(user: authResult?.user)))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func signInWithApple(
        idTokenString: String,
        nonce: String,
        fullName: PersonNameComponents?
    ) -> AnyPublisher<Member?, Error> {
        Future { promise in
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString, rawNonce: nonce, fullName: fullName)
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error as NSError? {
                    promise(.failure(self.handleAuthError(error)))
                } else {
                    promise(.success(Member(user: authResult?.user)))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func createUser(
        email: String,
        password: String,
        name: String
    ) -> AnyPublisher<Member?, Error> {
        Future { promise in
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error as NSError? {
                    promise(.failure(self.handleAuthError(error)))
                } else {
                    promise(.success(Member(user: authResult?.user)))
                }
            }
        }.eraseToAnyPublisher()
    }

    func signOut() -> AnyPublisher<Void, Error> {
        Future { promise in
            do {
                try Auth.auth().signOut()
                promise(.success(()))
            } catch let signOutError as NSError {
                promise(.failure(self.handleAuthError(signOutError)))
            }
        }.eraseToAnyPublisher()
    }
}
