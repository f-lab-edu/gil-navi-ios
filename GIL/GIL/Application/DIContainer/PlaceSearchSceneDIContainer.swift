//
//  PlaceSearchSceneDIContainer.swift
//  GIL
//
//  Created by 송우진 on 5/21/24.
//

import UIKit

final class PlaceSearchSceneDIContainer: PlaceSearchFlowCoordinatorDependencies {
    
    func makeLocationService() -> LocationService {
        LocationService()
    }
    
    // MARK: - Use Cases
    func makePlaceSearchUseCase() -> PlaceSearchUseCase {
        DefaultPlaceSearchUseCase()
    }
    
    // MARK: - Repositories
    func makePlaceRepository() -> PlaceRepository {
        DefaultPlaceRepository()
    }
    
    // MARK: - PlaceSearch
    func makePlaceSearchViewController(actions: PlaceSearchViewModelActions) -> PlaceSearchViewController {
        PlaceSearchViewController(
            viewModel: makePlaceSearchViewModel(actions: actions)
        )
    }
    
    func makePlaceSearchViewModel(actions: PlaceSearchViewModelActions) -> PlaceSearchViewModel {
        DefaultPlaceSearchViewModel(
            placeSearchUseCase: makePlaceSearchUseCase(),
            placeRepository: makePlaceRepository(),
            actions: actions,
            locationService: makeLocationService()
        )
    }
    
    // MARK: - Flow Coordinators
    func makePlaceSearchFlowCoordinator(navigationController: UINavigationController?) -> PlaceSearchFlowCoordinator {
        PlaceSearchFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}
