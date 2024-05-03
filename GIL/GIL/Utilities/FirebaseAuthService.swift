//
//  FirebaseAuthService.swift
//  GIL
//
//  Created by 송우진 on 5/2/24.
//

import Foundation
import FirebaseAuth

protocol FirebaseAuthServiceProtocol {
    static func registerAuthStateDidChangeHandler()
    static func signOut() throws
    static func signIn(with credential: OAuthCredential) async -> Result<AuthDataResult, FirebaseAuthError>
}

/// `FirebaseAuthService`의 작업 중 발생할 수 있는 인증 관련 에러를 정의합니다.
/// - firebaseError(error: Error) : Firebase 인증 과정에서 발생한 에러
/// - unknownAuthFailure : 에러가 발생 원인이 불분명하거나 예상치 못한 인증 실패
enum FirebaseAuthError: Error {
    case firebaseError(error: Error)
    case unknownAuthFailure
    
    var errorDescription: String {
        switch self {
        case .unknownAuthFailure:
            return "Firebase 인증에 실패했습니다."
        case .firebaseError(error: let error):
            return error.localizedDescription
        }
    }
}

final class FirebaseAuthService: FirebaseAuthServiceProtocol {
    static let authStateDidChangeNotification = Notification.Name("FirebaseAuthStateDidChangeNotification")
    
    static func registerAuthStateDidChangeHandler() {
        Auth.auth().addStateDidChangeListener { _, user in
            NotificationCenter.default.post(name: FirebaseAuthService.authStateDidChangeNotification, object: user)
        }
    }
    
    static func signOut() throws {
        try Auth.auth().signOut()
    }
    
    static func signIn(with credential: OAuthCredential) async -> Result<AuthDataResult, FirebaseAuthError> {
        await withCheckedContinuation { continuation in
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    continuation.resume(returning: .failure(.firebaseError(error: error)))
                }
                
                if let result = result {
                    continuation.resume(returning: .success(result))
                } else {
                    continuation.resume(returning: .failure(.unknownAuthFailure))
                }
            }
        }
    }
}
