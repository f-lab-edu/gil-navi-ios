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
    
    // MARK: - Initialization
    init(
        window: UIWindow,
        appDIContainer: AppDIContainer
    ) {
        self.window = window
        self.appDIContainer = appDIContainer
    }
}

extension AppFlowCoordinator {
    func start() {
        appDIContainer.firebaseAuthManager.authStateDidChangePublisher
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
        let authenticationSceneDIContainer = appDIContainer.makeAuthenticationDIContainer()
        let flow = authenticationSceneDIContainer.makeAuthenticationFlowCoordinator(window: window)
        flow.start()
    }
    
    private func showHomeViewController() {
        let homeSceneDIContainer = appDIContainer.makeHomeDIContainer()
        let flow = homeSceneDIContainer.makeHomeFlowCoordinator(window: window, appDIContainer: appDIContainer)
        flow.start()
    }
}
