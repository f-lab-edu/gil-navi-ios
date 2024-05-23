//
//  RouteFinderSceneDIContainer.swift
//  GIL
//
//  Created by 송우진 on 5/23/24.
//

import UIKit

final class RouteFinderSceneDIContainer: RouteFinderFlowCoordinatorDependencies {
    // MARK: - RouteMap
    func makeRouteMapViewController(
        departureMapLocation: MapLocation?,
        destinationMapItem: MapItem
    ) -> RouteMapViewController {
        RouteMapViewController(
            viewModel: makeRouteMapViewModel(departureMapLocation: departureMapLocation, destinationMapItem: destinationMapItem)
        )
    }
    
    func makeRouteMapViewModel(
        departureMapLocation: MapLocation?,
        destinationMapItem: MapItem
    ) -> RouteMapViewModel {
        RouteMapViewModel(
            departureMapLocation: departureMapLocation,
            destinationMapItem: destinationMapItem
        )
    }
    
    // MARK: - Flow Coordinators
    func makeRouteFinderFlowCoordinator(navigationController: UINavigationController?) -> RouteFinderFlowCoordinator {
        RouteFinderFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}
