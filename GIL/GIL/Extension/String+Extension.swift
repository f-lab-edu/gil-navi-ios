//
//  String+Extension.swift
//  GIL
//
//  Created by 송우진 on 4/1/24.
//

import Foundation
import RegexBuilder

// MARK: - 정규식
extension String {
    // 영문자와 숫자만 포함
    static let alphanumericRegex = "^[A-Za-z0-9]+$"
    // 최소 하나의 대문자를 포함
    static let uppercaseLetterRegex = ".*[A-Z]+.*"
    // 최소 하나의 소문자를 포함
    static let lowercaseLetterRegex = ".*[a-z]+.*"
    // 최소 하나의 숫자를 포함
    static let numberRegex = ".*[0-9]+.*"
}

// MARK: - 회원가입, 로그인에 필요한 유효성 검사
extension String {
    
    /**
     주어진 문자열이 유효한 이메일 주소인지 검사
     - Returns: 이메일 주소가 유효한 경우 true, 그렇지 않은 경우 false를 반환
     */
    func isValidEmail() -> Bool {
        let pattern = Regex {
            OneOrMore {
                ChoiceOf {
                    "a"..."z"
                    "A"..."Z"
                    "0"..."9"
                    "."
                    "_"
                }
            }
            "@"
            OneOrMore {
                ChoiceOf {
                    "a"..."z"
                    "A"..."Z"
                    "0"..."9"
                    "."
                }
            }
            "."
            OneOrMore {
                ChoiceOf {
                    "a"..."z"
                    "A"..."Z"
                }
            }
        }

        return self.wholeMatch(of: pattern) != nil
    }
    
    /**
     비밀번호 유효성 검사
     - Returns: 비밀번호 유효성 검사 결과. 다음 조건을 모두 만족해야 `true`반환
     - 최소 10자 이상
     - 적어도 하나의 대문자를 포함
     - 적어도 하나의 숫자를 포함
     - 특수 문자 포함 ( !@#$%^&*()-_=+[{]}\\|;:'\",<.>/? )
     */
    func isValidPassword() -> Bool {
        let specialCharacters = CharacterClass.anyOf("!@#$%^&*()-_=+[{]}\\|;:'\",<.>/?")

        guard self.count >= 10 else {
            return false
        }
        
        let digitPattern = Regex {
            OneOrMore(CharacterClass.digit)
        }

        let specialCharPattern = Regex {
            OneOrMore(specialCharacters)
        }
        
        let uppercasePattern = Regex {
            OneOrMore {
                ChoiceOf {
                    "A"..."Z"
                }
            }
        }
        
        
        let hasDigit = self.contains(digitPattern)
        let hasSpecialCharacter = self.contains(specialCharPattern)
        let hasUppercase = self.contains(uppercasePattern)
        
        return hasDigit && hasUppercase && hasSpecialCharacter
    }
}
