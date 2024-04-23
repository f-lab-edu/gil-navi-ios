//
//  FirebaseAuthError.swift
//  GIL
//
//  Created by 송우진 on 4/23/24.
//

import Foundation

/// Firebase 인증 서비스와 상호작용하는 과정에서 발생할 수 있는 인증 관련 에러를 정의
enum FirebaseAuthError: Error {
    /// 에러가 발생 원인이 불분명하거나 예상치 못한 인증 실패
    case unknownAuthFailure
}

extension FirebaseAuthError {
    var errorDescription: String? {
        switch self {
        case .unknownAuthFailure:
            return "Firebase 인증에 실패했습니다."
        }
    }
}
