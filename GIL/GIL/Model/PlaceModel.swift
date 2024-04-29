//
//  PlaceModel.swift
//  GIL
//
//  Created by 송우진 on 4/29/24.
//

import MapKit

struct Place: Hashable {
    let name: String?
    let coordinate: CLLocationCoordinate2D
    let address: String?
    let phoneNumber: String?
    let url: URL?
    let category: String?
    let distance: Double?
}

// MARK: - Initialization
extension Place {
    init(
        from mapItem: MKMapItem,
        distance: Double? = nil
    ) {
        self.name = mapItem.name
        self.coordinate = mapItem.placemark.coordinate
        self.address = mapItem.placemark.title
        self.phoneNumber = mapItem.phoneNumber
        self.url = mapItem.url
        self.category = mapItem.pointOfInterestCategory?.rawValue
        self.distance = distance
    }
}

// MARK: - Hashable
extension Place {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(coordinate.latitude)
        hasher.combine(coordinate.longitude)
        hasher.combine(address)
        hasher.combine(phoneNumber)
        hasher.combine(url)
        hasher.combine(category)
        hasher.combine(distance)
    }
        
    static func == (lhs: Place, rhs: Place) -> Bool {
        lhs.name == rhs.name &&
        lhs.coordinate.latitude == rhs.coordinate.latitude &&
        lhs.coordinate.longitude == rhs.coordinate.longitude &&
        lhs.address == rhs.address &&
        lhs.phoneNumber == rhs.phoneNumber &&
        lhs.url == rhs.url &&
        lhs.category == rhs.category &&
        lhs.distance == rhs.distance
    }
}
