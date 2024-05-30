//
//  Distance.swift
//  GIL
//
//  Created by 송우진 on 5/24/24.
//

import Foundation

struct Distance: Hashable, Codable {
    var value: Double?
}

extension Distance {
    func formatDistanceAsDetailed() -> String? {
        value?.formatAsDetailedDistanceString()
    }
    
    func formatDistanceAsCompact() -> String? {
        value?.formatAsCompactDistanceString()
    }
}

private extension Double {
    /// - Returns: 1000미터 미만인 경우 미터 단위로, 그 이상인 경우 키로미터 단위로 반환됩니다. (예: "950 미터" 또는 "1.2 킬로미터").
    func formatAsDetailedDistanceString() -> String {
        (self < 1000) ? "\(Int(self))미터".localized() : String(format: "%.1f킬로미터", self / 1000).localized()
    }
    
    /// - Returns: 1000미터 미만인 경우 m 단위로, 그 이상인 경우 km 단위로 반환됩니다. (예: "950m" 또는 "1.2km").
    func formatAsCompactDistanceString() -> String {
        (self < 1000) ? "\(Int(self))m" : String(format: "%.1fkm", self / 1000)
    }
}
