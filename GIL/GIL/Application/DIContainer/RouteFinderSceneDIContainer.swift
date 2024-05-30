//
//  RouteFinderSceneDIContainer.swift
//  GIL
//
//  Created by 송우진 on 5/23/24.
//

import UIKit

final class RouteFinderSceneDIContainer: RouteFinderFlowCoordinatorDependencies {
    struct Dependencies {
        let routeManager: RouteManaging
    }
    
    private let dependencies: Dependencies

    // MARK: - Initialization
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Use Cases
    func makeRouteFinderUseCase() -> RouteFinderUseCase {
        DefaultRouteFinderUseCase(
            routeManager: dependencies.routeManager
        )
    }
    
    // MARK: - RoutePageSheet
    func makeRouteFinderSheetViewController() -> RouteFinderSheetViewController {
        RouteFinderSheetViewController(
            viewModel: makeRouteFinderSheetViewModel()
        )
    }
    
    func makeRouteFinderSheetViewModel() -> RouteFinderSheetViewModel {
        DefaultRouteFinderSheetViewModel(
            selectedTransport: .walking
        )
    }
    
    // MARK: - RouteMap
    func makeRouteMapViewController(
        departureMapLocation: MapLocation?,
        destinationMapItem: MapItem,
        actions: RouteMapViewModelActions
    ) -> RouteMapViewController {
        RouteMapViewController(
            viewModel: makeRouteMapViewModel(departureMapLocation: departureMapLocation, destinationMapItem: destinationMapItem, actions: actions)
        )
    }
    
    func makeRouteMapViewModel(
        departureMapLocation: MapLocation?,
        destinationMapItem: MapItem,
        actions: RouteMapViewModelActions
    ) -> RouteMapViewModel {
        DefaultRouteMapViewModel(
            departureMapLocation: departureMapLocation,
            destinationMapItem: destinationMapItem,
            routeFinderUseCase: makeRouteFinderUseCase(),
            actions: actions
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
