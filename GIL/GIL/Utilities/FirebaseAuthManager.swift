//
//  FirebaseAuthManager.swift
//  GIL
//
//  Created by 송우진 on 5/2/24.
//

import Foundation
import FirebaseAuth

protocol FirebaseAuthManagerProtocol {
    static var currentUser: User? { get }
    static func registerAuthStateDidChangeHandler()
    static func signInAnonymously()
    static func createUserAsync(with email: String, password: String) async throws -> AuthDataResult
    static func signOut() throws
    static func signInAsync(with email: String, password: String) async throws -> AuthDataResult
    static func signInAsync(with credential: OAuthCredential) async throws -> AuthDataResult
}

final class FirebaseAuthManager: FirebaseAuthManagerProtocol {
    static var currentUser: User? {
        get {
            Auth.auth().currentUser
        }
    }
    
    static let authStateDidChangeNotification = Notification.Name("FirebaseAuthStateDidChangeNotification")
    
    static func registerAuthStateDidChangeHandler() {
        Auth.auth().addStateDidChangeListener { _, user in
            NotificationCenter.default.post(name: FirebaseAuthManager.authStateDidChangeNotification, object: user)
        }
    }
    
    static func signInAnonymously() {
        Auth.auth().signInAnonymously()
    }
    
    static func signOut() throws {
        try Auth.auth().signOut()
    }
    
    static func createUserAsync(
        with email: String,
        password: String
    ) async throws -> AuthDataResult {
        try await Auth.auth().createUser(withEmail: email, password: password)
    }
    
    static func signInAsync(
        with email: String,
        password: String
    ) async throws -> AuthDataResult {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    static func signInAsync(with credential: OAuthCredential) async throws -> AuthDataResult {
        try await Auth.auth().signIn(with: credential)
    }
}
