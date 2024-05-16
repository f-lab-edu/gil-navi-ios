//
//  LoginViewUITests.swift
//  GILUITests
//
//  Created by 송우진 on 3/15/24.
//

import XCTest

final class LoginViewUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUp() {
         super.setUp()
        continueAfterFailure = false
        app.launch()
    }

    func test_로그인() {
        // "EmailTextField" 텍스트 필드를 찾아 탭합니다.
        app.textFields["EmailTextField"].tap()
        // 텍스트 필드에 이메일 주소를 입력합니다.
        app.textFields["EmailTextField"].typeText("test@mail.com")
        // 키보드에서 "next" 버튼을 탭하여 다음 입력 필드로 이동합니다.
        app.keyboards.buttons["next"].tap()
        // "PasswordTextField" 보안 텍스트 필드에 비밀번호를 입력합니다.
        app.secureTextFields["PasswordTextField"].typeText("TestTest1900@")
        // 키보드에서 "done" 버튼을 탭하여 키보드를 숨깁니다.
        app.keyboards.buttons["done"].tap()
        // "SignInButton" 버튼을 찾아 로그인을 시도하기 위해 탭합니다.
        app.buttons["SignInButton"].tap()
    }
}
