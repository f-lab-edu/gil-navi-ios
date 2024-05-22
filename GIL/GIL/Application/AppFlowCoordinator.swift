//
//  AppFlowCoordinator.swift
//  GIL
//
//  Created by 송우진 on 5/20/24.
//

import UIKit
import Combine

final class AppFlowCoordinator {
    private var cancellables: Set<AnyCancellable> = []
    private var window: UIWindow
    private let appDIContainer: AppDIContainer
    private let firebaseAuthManager: FirebaseAuthManaging
    
    // MARK: - Initialization
    init(
        window: UIWindow,
        appDIContainer: AppDIContainer,
        firebaseAuthManager: FirebaseAuthManaging
    ) {
        self.window = window
        self.appDIContainer = appDIContainer
        self.firebaseAuthManager = firebaseAuthManager
    }
}

extension AppFlowCoordinator {
    func start() {
        firebaseAuthManager.authStateDidChangePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] user in
                if user != nil {
                    self?.showHomeViewController()
                } else {
                    self?.showLoginViewController()
                }
            }
            .store(in: &cancellables)
    }
    
    private func showLoginViewController() {
        let authenticationSceneDIContainer = appDIContainer.makeAuthenticationDIContainer(firebaseAuthManager: firebaseAuthManager)
        let flow = authenticationSceneDIContainer.makeAuthenticationFlowCoordinator(window: window)
        flow.start()
    }
    
    private func showHomeViewController() {
        let homeSceneDIContainer = appDIContainer.makeHomeDIContainer()
        let flow = homeSceneDIContainer.makeHomeFlowCoordinator(window: window, appDIContainer: appDIContainer)
        flow.start()
    }
}
