//
//  HomeViewModel.swift
//  GIL
//
//  Created by 송우진 on 4/4/24.
//

import FirebaseAuth

class HomeViewModel {
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            Log.error("Error signing out: \(signOutError)")
        }
    }
}
