//
//  HomeSceneDIContainer.swift
//  GIL
//
//  Created by 송우진 on 5/21/24.
//

import UIKit

final class HomeSceneDIContainer: HomeFlowCoordinatorDependencies {
    // MARK: - Home
    func makeHomeViewController(actions: HomeActions) -> HomeViewController {
        HomeViewController(actions: actions)
    }
    
    // MARK: - Flow Coordinators
    func makeHomeFlowCoordinator(
        window: UIWindow,
        appDIContainer: AppDIContainer
    ) -> HomeFlowCoordinator {
        HomeFlowCoordinator(
            window: window,
            dependencies: self,
            appDIContainer: appDIContainer
        )
    }
}
