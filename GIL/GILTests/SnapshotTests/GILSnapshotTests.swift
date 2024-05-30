//
//  GILSnapshotTests.swift
//  GILTests
//
//  Created by 송우진 on 5/27/24.
//

import XCTest
import SnapshotTesting
import CoreLocation
import MapKit
@testable import GIL

final class GILSnapshotTests: XCTestCase {
    func test_로그인화면() {
        let mockAuthManager = MockFirebaseAuthManager()
        let dependencies = AuthenticationSceneDIContainer.Dependencies(firebaseAuthManager: mockAuthManager)
        let diContainer = AuthenticationSceneDIContainer(dependencies: dependencies)
        
        let actions = LoginViewModelActions(showSignUp: {})
        let loginViewController = diContainer.makeLoginViewController(actions: actions)
        
        assertSnapshot(of: loginViewController, as: .image)
    }
    
    func test_회원가입화면() {
        let mockAuthManager = MockFirebaseAuthManager()
        let dependencies = AuthenticationSceneDIContainer.Dependencies(firebaseAuthManager: mockAuthManager)
        let diContainer = AuthenticationSceneDIContainer(dependencies: dependencies)
        
        let signUpViewController = diContainer.makeSignUpViewController()
        assertSnapshot(of: signUpViewController, as: .image)
    }
    
    func test_장소검색화면() {
        let diContainer = PlaceSearchSceneDIContainer()
        
        let actions = PlaceSearchViewModelActions(showRouteFinder: {_,_ in })
        let placeSearchViewController = diContainer.makePlaceSearchViewController(actions: actions)
        
        assertSnapshot(of: placeSearchViewController, as: .image)
    }
    
    func test_경로안내화면() {
        let mockRouteManager = MockRouteManager()
        let dependencies = RouteFinderSceneDIContainer.Dependencies(routeManager: mockRouteManager)
        let diContainer = RouteFinderSceneDIContainer(dependencies: dependencies)
        
        let mapLocation = MapLocation(CLLocation(latitude: 37.785824, longitude: -122.406417))
        let mapItem = MapItem(mapItem: MKMapItem(), distance: nil)
        let actions = RouteMapViewModelActions(showRouteFinderPageSheet: {})
        let routeMapViewController = diContainer.makeRouteMapViewController(
            departureMapLocation: mapLocation,
            destinationMapItem: mapItem,
            actions: actions
        )
        assertSnapshot(of: routeMapViewController, as: .image)
        
        let routeFinderSheetViewController = diContainer.makeRouteFinderSheetViewController()
        assertSnapshot(of: routeFinderSheetViewController, as: .image)
    }
}
