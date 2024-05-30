//
//  AppDIContainer.swift
//  GIL
//
//  Created by 송우진 on 5/21/24.
//

import Foundation

final class AppDIContainer {
    lazy var firebaseAuthManager = FirebaseAuthManager()
    lazy var routeManager = RouteManager()
    
    // MARK: - DIContainers of scenes
    func makeAuthenticationDIContainer() -> AuthenticationSceneDIContainer {
        let dependencies = AuthenticationSceneDIContainer.Dependencies(
            firebaseAuthManager: firebaseAuthManager
        )
        return AuthenticationSceneDIContainer(dependencies: dependencies)
    }
    
    func makeHomeDIContainer() -> HomeSceneDIContainer {
        HomeSceneDIContainer()
    }
    
    func makePlaceSearchDIContainer() -> PlaceSearchSceneDIContainer {
        PlaceSearchSceneDIContainer()
    }
    
    func makeRouteFinderDIContainer() -> RouteFinderSceneDIContainer {
        let dependencies = RouteFinderSceneDIContainer.Dependencies(
            routeManager: routeManager
        )
        return RouteFinderSceneDIContainer(dependencies: dependencies)
    }
}
