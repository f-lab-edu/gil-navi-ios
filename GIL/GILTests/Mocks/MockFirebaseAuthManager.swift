//
//  MockFirebaseAuthManager.swift
//  GILTests
//
//  Created by 송우진 on 5/27/24.
//

import Combine
import Foundation
import FirebaseAuth
@testable import GIL

class MockFirebaseAuthManager: FirebaseAuthManaging {
    var authStateDidChangePublisher: AnyPublisher<User?, Never> {
        Just(nil).eraseToAnyPublisher()
    }
    
    func signInWithEmail(email: String, password: String) -> AnyPublisher<GIL.Member?, Error> {
        Just(Member(user: nil))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func signInWithApple(idTokenString: String, nonce: String, fullName: PersonNameComponents?) -> AnyPublisher<GIL.Member?, Error> {
        Just(Member(user: nil))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func createUser(email: String, password: String, name: String) -> AnyPublisher<GIL.Member?, Error> {
        Just(Member(user: nil))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func signOut() -> AnyPublisher<Void, Error> {
        Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
