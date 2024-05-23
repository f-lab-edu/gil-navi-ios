//
//  AuthenticationSceneDIContainer.swift
//  GIL
//
//  Created by 송우진 on 5/21/24.
//

import UIKit

final class AuthenticationSceneDIContainer: AuthenticationFlowCoordinatorDependencies {

    struct Dependencies {
        let firebaseAuthManager: FirebaseAuthManaging
    }
    
    private let dependencies: Dependencies

    // MARK: - Initialization
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Use Cases
    func makeAuthenticationUseCase() -> AuthenticationUseCase {
        DefaultAuthenticationUseCase(
            firebaseAuthManager: dependencies.firebaseAuthManager
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
