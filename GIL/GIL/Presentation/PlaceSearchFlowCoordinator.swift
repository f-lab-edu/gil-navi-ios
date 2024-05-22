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
    
    // MARK: - Initialization
    init(
        navigationController: UINavigationController?,
        dependencies: PlaceSearchFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = PlaceSearchViewModelActions(showRouteFinder: showRouteFinder)
        let vc = dependencies.makePlaceSearchViewController(actions: actions)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showRouteFinder(departureMapLocation: MapLocation?, destinationMapItem: MapItem) {
        let viewModel = RouteMapViewModel(departureMapLocation: departureMapLocation, destinationMapItem: destinationMapItem)
        let vc = RouteMapViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}
