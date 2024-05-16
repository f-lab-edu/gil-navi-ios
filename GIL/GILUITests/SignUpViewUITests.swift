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
        // "SignUpButton" 버튼을 찾아 탭하여 회원가입 화면으로 이동합니다.
        app.buttons["SignUpButton"].tap()
        // "CloseButton" 버튼을 찾아 탭하여 회원가입 화면을 나갑니다.
        app.buttons["CloseButton"].tap()
        // "SignUpButton" 버튼을 찾아 탭하여 회원가입 화면으로 다시 이동합니다.
        app.buttons["SignUpButton"].tap()
        
        let testEmail = UUID().uuidString.replacingOccurrences(of: "-", with: "") + "@mail.com"
        // "EmailTextField" 텍스트 필드를 찾아 탭합니다.
        app.textFields["EmailTextField"].tap()
        // 선택된 텍스트 필드에 이메일 주소를 입력합니다.
        app.textFields["EmailTextField"].typeText(testEmail)
        
        // "NameTextField" 텍스트 필드를 찾아 탭합니다.
        app.textFields["NameTextField"].tap()
        // 선택된 텍스트 필드에 이름을 입력합니다.
        app.textFields["NameTextField"].typeText("TEST계정")
        
        let testPassword = "TestTest9999@@"
        // "PasswordTextField" 보안 텍스트 필드를 찾아 탭합니다.
        app.secureTextFields["PasswordTextField"].tap()
        // 선택된 보안 텍스트 필드에 비밀번호를 입력합니다.
        app.secureTextFields["PasswordTextField"].typeText(testPassword)
        // "VerifyPasswordTextField" 보안 텍스트 필드를 찾아 탭합니다.
        app.secureTextFields["VerifyPasswordTextField"].tap()
        // 선택된 보안 텍스트 필드에 비밀번호를 다시 입력합니다.
        app.secureTextFields["VerifyPasswordTextField"].typeText(testPassword)
        
        // "DoneButton" 버튼을 찾아 회원가입을 시도하기 위해 탭합니다.
        app.buttons["DoneButton"].tap()
    }
    
}
