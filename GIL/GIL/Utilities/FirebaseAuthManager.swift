//
//  FirebaseAuthManager.swift
//  GIL
//
//  Created by 송우진 on 5/2/24.
//

import FirebaseAuth
import Combine
import AuthenticationServices

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
}

extension FirebaseAuthManager {
    func signInWithEmail(
        email: String,
        password: String
    ) -> AnyPublisher<Member?, Error> {
        Future { promise in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    promise(.failure(error))
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
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(Member(user: authResult?.user)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func createUser(
        email: String,
        password: String,
        name: String
    ) -> AnyPublisher<Member?, Error> {
        Future { promise in
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    promise(.failure(error))
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
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
}
