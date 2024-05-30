//
//  Route.swift
//  GIL
//
//  Created by 송우진 on 5/13/24.
//

import MapKit

struct Route: Hashable {
    let expectedTravelTime: TimeInterval
    let polyline: CustomPolyline
    let distance: Distance
    
    init(_ route: MKRoute) {
        expectedTravelTime = route.expectedTravelTime
        distance = Distance(value: route.distance)
        
        let coordinates = Array(UnsafeBufferPointer(start: route.polyline.points(), count: route.polyline.pointCount))
        let customPolyline = CustomPolyline(points: coordinates, count: coordinates.count)
        polyline = customPolyline
    }
    
    func formatTravelTimeAsHourMinute() -> String {
        expectedTravelTime.toHourMinuteFormat()
    }
}

final class CustomPolyline: MKPolyline {
    var isSelected: Bool = false
}

private extension TimeInterval {
    /// 시간은 시와 분을 표시하는 형식의 문자열로 반환합니다
    /// - Returns: 1시간 미만인 경우 분 단위로, 그 이상인 경우 시간, 분 단위로 반환됩니다. (예: "30분" 또는 "1시간 30분")
    func toHourMinuteFormat() -> String {
        let hours = Int(self / 3600)
        let minutes = Int((self.truncatingRemainder(dividingBy: 3600)) / 60)
        if hours > 0 {
            return String(format: "%2d시간 %2d분", hours, minutes).localized()
        } else {
            return String(format: "%d분", minutes).localized()
        }
    }
}


