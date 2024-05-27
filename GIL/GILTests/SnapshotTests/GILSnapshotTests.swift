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
        
        assertSnapshot(matching: loginViewController, as: .image, named: "login_view_controller", testName: "ViewController")
    }
    
    func test_회원가입화면() {
        let mockAuthManager = MockFirebaseAuthManager()
        let dependencies = AuthenticationSceneDIContainer.Dependencies(firebaseAuthManager: mockAuthManager)
        let diContainer = AuthenticationSceneDIContainer(dependencies: dependencies)
        
        let signUpViewController = diContainer.makeSignUpViewController()
        assertSnapshot(matching: signUpViewController, as: .image, named: "sign_up_view_controller", testName: "ViewController")
    }
    
}
