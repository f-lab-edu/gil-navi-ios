//
//  AuthenticationFlowCoordinator.swift
//  GIL
//
//  Created by 송우진 on 5/21/24.
//

import UIKit

protocol AuthenticationFlowCoordinatorDependencies {
    func makeLoginViewController(actions: LoginViewModelActions) -> LoginViewController
    func makeSignUpViewController() -> SignUpViewController
}

final class AuthenticationFlowCoordinator {
    private weak var window: UIWindow?
    private weak var navigationController: UINavigationController?
    private let dependencies: AuthenticationFlowCoordinatorDependencies
    
    // MARK: - Initialization
    init(
        window: UIWindow,
        dependencies: AuthenticationFlowCoordinatorDependencies
    ) {
        self.window = window
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = LoginViewModelActions(showSignUp: showSignUp)
        let vc = dependencies.makeLoginViewController(actions: actions)
        let rootVC = UINavigationController(rootViewController: vc)
        navigationController = rootVC
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }
    
    private func showSignUp() {
        let vc = dependencies.makeSignUpViewController()
        vc.modalPresentationStyle = .fullScreen
        navigationController?.present(vc, animated: true)
    }
}
