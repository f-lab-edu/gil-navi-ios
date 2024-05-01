//
//  AuthExtensionTests.swift
//  GILTests
//
//  Created by 송우진 on 5/1/24.
//

import XCTest
import FirebaseAuth
@testable import GIL

final class AuthExtensionTests: XCTestCase {
    var auth: Auth!

    override func setUp() {
        super.setUp()
        auth = Auth.auth()
    }

    override func tearDown() {
        auth = nil
        super.tearDown()
    }

    func test_사용자생성성공() async {
        do {
            let uniqueEmail = "test\(UUID().uuidString)@example.com"
            let result = try await auth.createUserAsync(withEmail: uniqueEmail, password: "Qwerty123!")
            XCTAssertEqual(result.user.email?.lowercased(), uniqueEmail.lowercased(), "생성된 사용자의 이메일이 입력된 이메일과 일치해야 합니다")
        } catch {
            XCTFail("사용자 생성에 실패해서는 안 됩니다: \(error)")
        }
    }

    func test_사용자생성실패_이메일형식불일치() async {
        do {
            let _ = try await auth.createUserAsync(withEmail: "test-email", password: "Qwerty123!")
            XCTFail("잘못된 이메일 형식에 대해 실패해야 합니다")
        } catch {
            XCTAssert(true, "올바르게 에러 처리되어야 합니다: \(error)")
        }
    }

    func test_사용자생성실패_비밀번호약함() async {
        do {
            let _ = try await auth.createUserAsync(withEmail: "test@example.com", password: "123")
            XCTFail("비밀번호에 대해 실패해야 합니다")
        } catch {
            XCTAssert(true, "올바르게 에러 처리되어야 합니다: \(error)")
        }
    }
}
