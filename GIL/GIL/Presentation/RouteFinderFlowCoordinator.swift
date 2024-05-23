//
//  RouteFinderFlowCoordinator.swift
//  GIL
//
//  Created by 송우진 on 5/23/24.
//

import UIKit

protocol RouteFinderFlowCoordinatorDependencies {
    func makeRouteMapViewController(departureMapLocation: MapLocation?, destinationMapItem: MapItem) -> RouteMapViewController
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
        let viewController = dependencies.makeRouteMapViewController(departureMapLocation: departureMapLocation, destinationMapItem: destinationMapItem)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
