//
//  AppDIContainer.swift
//  GIL
//
//  Created by 송우진 on 5/21/24.
//

import Foundation

final class AppDIContainer {
    // MARK: - DIContainers of scenes
    func makeAuthenticationDIContainer(firebaseAuthManager: FirebaseAuthManaging) -> AuthenticationSceneDIContainer {
        AuthenticationSceneDIContainer(
            firebaseAuthManager: firebaseAuthManager
        )
    }
}
