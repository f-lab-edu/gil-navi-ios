//
//  HomeFlowCoordinator.swift
//  GIL
//
//  Created by 송우진 on 5/21/24.
//

import UIKit

protocol HomeFlowCoordinatorDependencies {
    func makeHomeViewController(actions: HomeActions) -> HomeViewController
}

final class HomeFlowCoordinator {
    private weak var window: UIWindow?
    private weak var navigationController: UINavigationController?
    private let dependencies: HomeFlowCoordinatorDependencies
    private let appDIContainer: AppDIContainer
    
    // MARK: - Initialization
    init(
        window: UIWindow,
        dependencies: HomeFlowCoordinatorDependencies,
        appDIContainer: AppDIContainer
    ) {
        self.window = window
        self.dependencies = dependencies
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        let actions = HomeActions(
            showPlaceSearch: showPlaceSearch,
            showRouteFinder: showRouteFinder
        )
        let vc = dependencies.makeHomeViewController(actions: actions)
        let rootVC = UINavigationController(rootViewController: vc)
        navigationController = rootVC
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }
    
    private func showPlaceSearch() {
        let placeSearchSceneDIContainer = appDIContainer.makePlaceSearchDIContainer()
        let flow = placeSearchSceneDIContainer.makePlaceSearchFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
    
    private func showRouteFinder(destinationMapItem: MapItem) {
        let viewModel = RouteMapViewModel(
            departureMapLocation: nil,
            destinationMapItem: destinationMapItem
        )
        let vc = RouteMapViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}
