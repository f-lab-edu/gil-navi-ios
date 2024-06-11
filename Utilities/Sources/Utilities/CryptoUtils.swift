//
//  CryptoUtils.swift
//  GIL
//
//  Created by 송우진 on 5/2/24.
//

import Foundation
import CryptoKit

/// `CryptoUtils`의 작업 중 발생할 수 있는 에러를 정의합니다.
/// - randomBytesGenerationFailed : 난수 생성에 실패했을 때 발생하는 에러입니다.
enum CryptoUtilsError: Error {
    case randomBytesGenerationFailed(String)
}

enum CryptoUtils {
    static func randomNonceString(length: Int = 32) throws -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
          throw CryptoUtilsError.randomBytesGenerationFailed("난수 생성 실패 (\(errorCode))")
      }
      let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      let nonce = randomBytes.map { charset[Int($0) % charset.count] }
      return String(nonce)
    }

    static func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap { String(format: "%02x", $0) }.joined()

      return hashString
    }
}
