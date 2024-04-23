//
//  HomeInteractor.swift
//  GIL
//
//  Created by 송우진 on 4/23/24.
//

import FirebaseAuth

protocol HomeBusinessLogic {
    func signOut()
}

final class HomeInteractor: HomeBusinessLogic {
    var presenter: HomePresentationLogic?
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            Log.error("Error signing out: \(signOutError)")
        }
    }
}
