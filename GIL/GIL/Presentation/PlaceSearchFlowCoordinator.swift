//
//  PlaceSearchFlowCoordinator.swift
//  GIL
//
//  Created by 송우진 on 5/21/24.
//

import UIKit

protocol PlaceSearchFlowCoordinatorDependencies {
    func makePlaceSearchViewController(actions: PlaceSearchViewModelActions) -> PlaceSearchViewController
}

final class PlaceSearchFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: PlaceSearchFlowCoordinatorDependencies
    private let appDIContainer: AppDIContainer
    
    // MARK: - Initialization
    init(
        navigationController: UINavigationController?,
        dependencies: PlaceSearchFlowCoordinatorDependencies,
        appDIContainer: AppDIContainer
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        let actions = PlaceSearchViewModelActions(
            showRouteFinder: showRouteFinder
        )
        let viewController = dependencies.makePlaceSearchViewController(actions: actions)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showRouteFinder(
        departureMapLocation: MapLocation?,
        destinationMapItem: MapItem
    ) {
        let routeMapSceneDIContainer = appDIContainer.makeRouteFinderDIContainer()
        let flow = routeMapSceneDIContainer.makeRouteFinderFlowCoordinator(navigationController: navigationController)
        flow.start(departureMapLocation: departureMapLocation, destinationMapItem: destinationMapItem)
    }

}
