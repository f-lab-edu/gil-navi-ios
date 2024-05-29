//
//  AuthenticationUseCaseTests.swift
//  GILTests
//
//  Created by 송우진 on 5/29/24.
//

import XCTest
import Combine
import FirebaseAuth
@testable import GIL

final class AuthenticationUseCaseTests: XCTestCase {
    var mockAuthManager: MockFirebaseAuthManager!
    var authenticationUseCase: AuthenticationUseCase!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockAuthManager = MockFirebaseAuthManager()
        let dependencies = AuthenticationSceneDIContainer.Dependencies(firebaseAuthManager: mockAuthManager)
        let diContainer = AuthenticationSceneDIContainer(dependencies: dependencies)
        authenticationUseCase = diContainer.makeAuthenticationUseCase()
        cancellables = []
    }
    
    override func tearDown() {
        mockAuthManager = nil
        authenticationUseCase = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_이메일과비밀번호가올바를때_로그인을요청하면_로그인성공() {
        // Given
        let expectation = XCTestExpectation(description: "이메일 로그인 성공")
        let member = Member()
        mockAuthManager.signInWithEmailResult = .success(member)
        
        // When
        authenticationUseCase.signInWithEmail(email: "test@example.com", password: "Test19001900@")
            .sink(receiveCompletion: { completion in
                guard case .finished = completion else { return }
            }, receiveValue: { receivedMember in
                // Then
                XCTAssertEqual(receivedMember, member)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_이메일로그인정보가틀릴때_로그인을요청하면_로그인실패() {
        // Given
        let expectation = XCTestExpectation(description: "이메일 로그인 실패")
        let error = FirebaseAuthError.customError(description: "이메일 로그인 실패")
        mockAuthManager.signInWithEmailResult = .failure(error)
        
        // When
        authenticationUseCase.signInWithEmail(email: "test@example.com", password: "1900")
            .sink(receiveCompletion: { completion in
                if case let .failure(receivedError as FirebaseAuthError) = completion {
                    // Then
                    XCTAssertEqual(receivedError, error)
                    expectation.fulfill()
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

}
