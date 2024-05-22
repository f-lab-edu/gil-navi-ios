//
//  Route.swift
//  GIL
//
//  Created by 송우진 on 5/13/24.
//

import MapKit

struct Route: Hashable {
    let expectedTravelTime: TimeInterval
    let polyline: MKPolyline
    let distance: Double
    
    init(_ route: MKRoute) {
        expectedTravelTime = route.expectedTravelTime
        polyline = route.polyline
        distance = route.distance
    }
}
