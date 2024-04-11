//
//  String+Extension.swift
//  GIL
//
//  Created by 송우진 on 4/1/24.
//

import Foundation

extension String {
    /**
     주어진 키에 대한 지역화된 문자열을 검색
     - Parameters:
        - key: 지역화될 문자열의 키
        - comment: 문자열에 대한 추가 컨텍스트를 제공할 수 있는 주석
     - Returns: 키와 연관된 지역화된 문자열 또는 키를 찾지 못한 경우 키 자체
     */
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
    
    /**
     주어진 문자열이 유효한 이메일 주소인지 검사
     - Returns: 이메일 주소가 유효한 경우 true, 그렇지 않은 경우 false를 반환
     */
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegex)
            let matches = regex.matches(in: self, range: NSRange(location: 0, length: self.utf16.count))
            return !matches.isEmpty
        } catch {
            return false
        }
    }
    
    /**
     비밀번호 유효성 검사 함수
     - Returns: 비밀번호 유효성 검사 결과. 다음 조건을 모두 만족해야 `true`반환
     - 최소 10자 이상
     - 적어도 하나의 소문자를 포함
     - 적어도 하나의 대문자를 포함
     - 적어도 하나의 숫자를 포함
     - 영문자와 숫자만을 포함
     */
    func isValidPassword() -> Bool {
        // 최소 10자 이상
        guard self.count >= 10 else {
            return false
        }

        // 영문자와 숫자만 포함
        let alphanumericRegex = "^[A-Za-z0-9]+$"
        let alphanumericTest = NSPredicate(format:"SELF MATCHES %@", alphanumericRegex)
        if !alphanumericTest.evaluate(with: self) {
            return false
        }

        // 대문자 포함
        let uppercaseLetterRegex = ".*[A-Z]+.*"
        let uppercaseLetterTest = NSPredicate(format:"SELF MATCHES %@", uppercaseLetterRegex)
        guard uppercaseLetterTest.evaluate(with: self) else {
            return false
        }

        // 소문자 포함
        let lowercaseLetterRegex = ".*[a-z]+.*"
        let lowercaseLetterTest = NSPredicate(format:"SELF MATCHES %@", lowercaseLetterRegex)
        guard lowercaseLetterTest.evaluate(with: self) else {
            return false
        }

        // 숫자 포함
        let numberRegex = ".*[0-9]+.*"
        let numberTest = NSPredicate(format:"SELF MATCHES %@", numberRegex)
        guard numberTest.evaluate(with: self) else {
            return false
        }

        return true
    }
}
