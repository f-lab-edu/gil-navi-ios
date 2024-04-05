//
//  GILTests.swift
//  GILTests
//
//  Created by 송우진 on 3/15/24.
//

import XCTest
@testable import GIL

final class GILTests: XCTestCase {
    var signUpVC: SignUpViewController!
    var signUpViewModel: SignUpViewModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        signUpViewModel = SignUpViewModel()
        signUpVC = SignUpViewController(viewModel: signUpViewModel)
        signUpVC.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        signUpVC = nil
        signUpViewModel = nil
    }
    

    func testInvalidEmailAndPasswordDisablesConfirmButton() {
        // 회원가입에 필요한 정보 설정
        signUpViewModel.emailPublisher.send("woojin@gmail.com")
        signUpViewModel.namePublisher.send("woojin")
        signUpViewModel.passwordPublisher.send("Woojin1900")
        signUpViewModel.confirmPasswordPublisher.send("Woojin1900")
        
        let expectation = XCTestExpectation(description: "Wait for validation")
        DispatchQueue.main.async {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)

        // 확인 버튼이 활성화되어야 함
        XCTAssertTrue(signUpVC.signUpView.confirmButton.isEnabled)
    }


}
