//
//  AuthenticationSceneDIContainer.swift
//  GIL
//
//  Created by 송우진 on 5/21/24.
//

import UIKit

final class AuthenticationSceneDIContainer: AuthenticationFlowCoordinatorDependencies {
    private let firebaseAuthManager: FirebaseAuthManaging

    // MARK: - Initialization
    init(firebaseAuthManager: FirebaseAuthManaging) {
        self.firebaseAuthManager = firebaseAuthManager
    }
    
    // MARK: - Use Cases
    func makeAuthenticationUseCase() -> AuthenticationUseCase {
        DefaultAuthenticationUseCase(
            firebaseAuthManager: firebaseAuthManager
        )
    }

    // MARK: - Login
    func makeLoginViewController(actions: LoginViewModelActions) -> LoginViewController {
        LoginViewController(
            viewModel: makeLoginViewModel(actions: actions)
        )
    }
    
    func makeLoginViewModel(actions: LoginViewModelActions) -> LoginViewModel {
        DefaultLoginViewModel(
            authenticationUseCase: makeAuthenticationUseCase(),
            actions: actions
        )
    }
    
    // MARK: - SignUp
    func makeSignUpViewController() -> SignUpViewController {
        SignUpViewController(
            viewModel: makeSignUpViewModel()
        )
    }
    
    func makeSignUpViewModel() -> SignUpViewModel {
        DefaultSignUpViewModel(
            authenticationUseCase: makeAuthenticationUseCase()
        )
    }
    
    // MARK: - Flow Coordinators
    func makeAuthenticationFlowCoordinator(window: UIWindow) -> AuthenticationFlowCoordinator {
        AuthenticationFlowCoordinator(
            window: window,
            dependencies: self
        )
    }
}
