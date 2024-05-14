//
//  Transport.swift
//  GIL
//
//  Created by 송우진 on 5/11/24.
//

import MapKit

/// MapKit에 적용할 이동 수단의 열거형입니다
/// - walking : 도보
/// - automobile: 운전
enum Transport: String {
    case walking = "도보"
    case automobile = "운전"
    
    /// MapKit에서 사용할 교통 수단 타입을 반환합니다
    /// - Returns: 해당 이동 수단에 맞는 `MKDirectionsTransportType`
    var mkTransportType: MKDirectionsTransportType {
        switch self {
        case .walking: return .walking
        case .automobile: return .automobile
        }
    }

    /// 이동 수단의 시스템 이미지 이름을 반환합니다
    /// - Returns: 해당 이동 수단에 맞는 시스템 이미지 이름
    var systemImageName: String {
        switch self {
        case .walking: return "figure.walk"
        case .automobile: return "car"
        }
    }
}
