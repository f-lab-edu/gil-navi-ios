//
//  Coordinate.swift
//  GIL
//
//  Created by 송우진 on 5/14/24.
//

import CoreLocation
import MapKit

struct Coordinate: Codable, Hashable {
    let latitude: Double?
    let longitude: Double?
}

extension Coordinate {
    func toCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude ?? 0.0, longitude: longitude ?? 0.0)
    }
    
    func toMKPlacemark() -> MKPlacemark {
        MKPlacemark(coordinate: toCLLocationCoordinate2D())
    }
    
    func toMKMapItem() -> MKMapItem {
        MKMapItem(placemark: toMKPlacemark())
    }
}
