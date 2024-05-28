//
//  GILSnapshotTests.swift
//  GILTests
//
//  Created by 송우진 on 5/27/24.
//

import XCTest
import SnapshotTesting
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
}
