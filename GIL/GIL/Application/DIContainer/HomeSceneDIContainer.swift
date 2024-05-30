//
//  HomeSceneDIContainer.swift
//  GIL
//
//  Created by 송우진 on 5/21/24.
//

import UIKit

final class HomeSceneDIContainer: HomeFlowCoordinatorDependencies {
    // MARK: - Repositories
    func makePlaceRepository() -> PlaceRepository {
        DefaultPlaceRepository()
    }
    
    // MARK: - Home
    func makeHomeViewController(actions: HomeActions) -> HomeViewController {
        HomeViewController(
            interactor: makeHomeInteractor(),
            presenter: makeHomePresenter(),
            actions: actions
        )
    }
    
    func makeHomeInteractor() -> HomeInteractor {
        HomeInteractor(
            placeRepository: makePlaceRepository()
        )
    }
    
    func makeHomePresenter() -> HomePresenter {
        HomePresenter()
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
