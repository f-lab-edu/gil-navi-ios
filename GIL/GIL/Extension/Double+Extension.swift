//
//  Double+Extension.swift
//  GIL
//
//  Created by 송우진 on 5/13/24.
//

import Foundation

extension Double {
    /// 거리를 간단한 문자열 형식으로 반환합니다
    /// - Returns: 1000미터 미만인 경우 m 단위로, 그 이상인 경우 km 단위로 반환됩니다. (예: "950m" 또는 "1.2km").
    func formattedDistanceCompact() -> String {
        if self < 1000 {
            return "\(Int(self))m"
        } else {
            return String(format: "%.1fkm", self / 1000)
        }
    }
    
    /// 거리를 상세한 문자열 형식으로 반환합니다
    /// - Returns: 1000미터 미만인 경우 미터 단위로, 그 이상인 경우 키로미터 단위로 반환됩니다. (예: "950 미터" 또는 "1.2 킬로미터").
    func formattedDistanceDetailed() -> String {
        if self < 1000 {
            return "\(Int(self))미터".localized()
        } else {
            return String(format: "%.1f킬로미터", self / 1000)
        }
    }
}
