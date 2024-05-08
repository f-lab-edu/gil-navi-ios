//
//  FirebaseAuth+Extension.swift
//  GIL
//
//  Created by 송우진 on 4/23/24.
//

import FirebaseAuth

extension Auth {
    /// Firebase Authentication을 사용하여 비동기적으로 새 사용자를 생성합니다.
    /// 이메일과 비밀번호를 사용하여 Firebase에 사용자를 등록하고,
    /// 성공적으로 사용자가 생성되면 `AuthDataResult`를 반환합니다.
    /// 실패하는 경우, 적절한 에러를 throw합니다.
    ///
    /// - Parameters:
    ///   - email: 사용자의 이메일 주소
    ///   - password: 사용자의 비밀번호
    /// - Returns: 비동기적으로 `AuthDataResult`를 반환합니다.
    func createUserAsync(
        withEmail email: String,
        pwd password: String
    ) async throws -> AuthDataResult {
        try await withCheckedThrowingContinuation { continuation in
            self.createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let result = result {
                    continuation.resume(returning: result)
                } else {
                    continuation.resume(throwing: FirebaseAuthError.unknownAuthFailure)
                }
            }
        }
    }
}
