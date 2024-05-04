//
//  PlaceModel.swift
//  GIL
//
//  Created by 송우진 on 4/29/24.
//

import MapKit

struct Place: Hashable, Codable {
    let name: String
    let address: String
    let category: String
    let distance: Double
    
    init(
        mapItem: MKMapItem,
        distance: Double = 0.0
    ) {
        self.name = mapItem.name ?? ""
        self.address = mapItem.placemark.title ?? ""
        self.category = mapItem.pointOfInterestCategory?.rawValue ?? ""
        self.distance = distance
    }
}
