//
//  Localizer.swift
//  GIL
//
//  Created by 송우진 on 4/11/24.
//

import Foundation

class Localizer {
    /**
     주어진 키에 대한 지역화된 문자열을 검색
     - Parameters:
        - key: 지역화될 문자열의 키
        - comment: 문자열에 대한 추가 컨텍스트를 제공할 수 있는 주석
     - Returns: 키와 연관된 지역화된 문자열 또는 키를 찾지 못한 경우 키 자체
     */
    static func localizedString(
        forKey key: String,
        comment: String = ""
    ) -> String {
        return NSLocalizedString(key, comment: "")
    }
}
