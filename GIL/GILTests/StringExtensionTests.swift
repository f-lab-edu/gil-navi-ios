//
//  StringExtensionTests.swift
//  GILTests
//
//  Created by 송우진 on 5/1/24.
//

import XCTest
@testable import GIL

final class StringExtensionTests: XCTestCase {

    func test_이메일유효성검사() {
        XCTAssertTrue("example@gmail.com".isValidEmail(), "유효한 이메일이어야 합니다")
        XCTAssertFalse("example.com".isValidEmail(), "@ 기호가 누락되어 유효하지 않아야 합니다")
        XCTAssertFalse("example@.com".isValidEmail(), "도메인 이름이 누락되어 유효하지 않아야 합니다")
        XCTAssertFalse("@example.com".isValidEmail(), "로컬 파트가 누락되어 유효하지 않아야 합니다")
    }

    func test_비밀번호유효성검사() {
        let password = "A1!a2b3c4d5e"
        let results = password.validatePassword()
        XCTAssertEqual(results, [true, true, true, true], "비밀번호가 모든 기준을 충족해야 합니다")
        
        let weakPassword = "abc"
        let weakResults = weakPassword.validatePassword()
        XCTAssertEqual(weakResults, [false, false, false, false], "비밀번호가 모든 조건을 충족하지 않아야 합니다")
    }

    func test_비밀번호전체유효성검사() {
        XCTAssertTrue("A1!a2b3c4d5e".isValidPassword(), "유효한 비밀번호여야 합니다")
        XCTAssertFalse("abcdef".isValidPassword(), "길이, 숫자 및 특수 문자가 누락되어 유효하지 않아야 합니다")
        XCTAssertFalse("Abcdefghi!".isValidPassword(), "숫자가 누락되어 유효하지 않아야 합니다")
        XCTAssertFalse("123abcdefg".isValidPassword(), "대문자와 특수 문자가 누락되어 유효하지 않아야 합니다")
    }
}
