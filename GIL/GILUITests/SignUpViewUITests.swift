//
//  SignUpViewUITests.swift
//  GILUITests
//
//  Created by 송우진 on 5/16/24.
//

import XCTest

final class SignUpViewUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUp() {
         super.setUp()
        continueAfterFailure = false
        app.launch()
    }
    
    func test_회원가입() {
        // "LoginViewSignUpButton" 버튼을 찾아 탭하여 회원가입 화면으로 이동합니다.
        app.buttons["LoginViewSignUpButton"].tap()
        // "SignUpViewCloseButton" 버튼을 찾아 탭하여 회원가입 화면을 나갑니다.
        app.buttons["SignUpViewCloseButton"].tap()
        // "LoginViewSignUpButton" 버튼을 찾아 탭하여 회원가입 화면으로 다시 이동합니다.
        app.buttons["LoginViewSignUpButton"].tap()
        
        let testEmail = UUID().uuidString.replacingOccurrences(of: "-", with: "") + "@mail.com"
        // "SignUpViewEmailTextField" 텍스트 필드를 찾아 탭합니다.
        app.textFields["SignUpViewEmailTextField"].tap()
        // 선택된 텍스트 필드에 이메일 주소를 입력합니다.
        app.textFields["SignUpViewEmailTextField"].typeText(testEmail)
        
        // "SignUpViewNameTextField" 텍스트 필드를 찾아 탭합니다.
        app.textFields["SignUpViewNameTextField"].tap()
        // 선택된 텍스트 필드에 이름을 입력합니다.
        app.textFields["SignUpViewNameTextField"].typeText("TEST계정")
        
        let testPwd = "TestTest9999@@"
        // "SignUpViewPasswordTextField" 보안 텍스트 필드를 찾아 탭합니다.
        app.secureTextFields["SignUpViewPasswordTextField"].tap()
        // 선택된 보안 텍스트 필드에 비밀번호를 입력합니다.
        app.secureTextFields["SignUpViewPasswordTextField"].typeText(testPwd)
        // "SignUpViewVerifyPasswordTextField" 보안 텍스트 필드를 찾아 탭합니다.
        app.secureTextFields["SignUpViewVerifyPasswordTextField"].tap()
        // 선택된 보안 텍스트 필드에 비밀번호를 다시 입력합니다.
        app.secureTextFields["SignUpViewVerifyPasswordTextField"].typeText(testPwd)
        
        // "SignUpViewDoneButton" 버튼을 찾아 회원가입을 시도하기 위해 탭합니다.
        app.buttons["SignUpViewDoneButton"].tap()
    }
    
}
