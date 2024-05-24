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
    let distance: Double
    
    init(_ route: MKRoute) {
        expectedTravelTime = route.expectedTravelTime
        distance = route.distance
        
        let coordinates = Array(UnsafeBufferPointer(start: route.polyline.points(), count: route.polyline.pointCount))
        let customPolyline = CustomPolyline(points: coordinates, count: coordinates.count)
        polyline = customPolyline
    }
}

class CustomPolyline: MKPolyline {
    var isSelected: Bool = false
}
