//
//  AuthenticationManager.swift
//  GIL
//
//  Created by 송우진 on 4/4/24.
//

import UIKit
import FirebaseAuth

class AuthenticationManager {
    static let shared = AuthenticationManager()
    
    func signIn() {
        Auth.auth().signInAnonymously()
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }

}
