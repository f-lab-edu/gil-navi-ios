//
//  CoordinateModel.swift
//  GIL
//
//  Created by 송우진 on 5/14/24.
//

import CoreLocation

struct CoordinateModel: Codable, Hashable {
    let latitude: Double?
    let longitude: Double?
}

extension CoordinateModel {
    func toCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude ?? 0.0, longitude: longitude ?? 0.0)
    }
}
