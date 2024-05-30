//
//  RouteFinderFlowCoordinator.swift
//  GIL
//
//  Created by 송우진 on 5/23/24.
//

import UIKit

protocol RouteFinderFlowCoordinatorDependencies {
    func makeRouteMapViewController(departureMapLocation: MapLocation?, destinationMapItem: MapItem, actions: RouteMapViewModelActions) -> RouteMapViewController
    func makeRouteFinderSheetViewController() -> RouteFinderSheetViewController
}

final class RouteFinderFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: RouteFinderFlowCoordinatorDependencies
    
    // MARK: - Initialization
    init(
        navigationController: UINavigationController?,
        dependencies: RouteFinderFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start(
        departureMapLocation: MapLocation?,
        destinationMapItem: MapItem
    ) {
        let actions = RouteMapViewModelActions(
            showRouteFinderPageSheet: showRouteFinderPageSheet
        )
        let viewController = dependencies.makeRouteMapViewController(departureMapLocation: departureMapLocation, destinationMapItem: destinationMapItem, actions: actions)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showRouteFinderPageSheet() {
        let viewController = dependencies.makeRouteFinderSheetViewController()
        viewController.delegate = navigationController?.topViewController as? RouteFinderSheetViewControllerDelegate
        navigationController?.present(viewController, animated: true)
    }
}
